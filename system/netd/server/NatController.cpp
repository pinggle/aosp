/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_NDEBUG 0

#include <stdlib.h>
#include <errno.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <cutils/properties.h>

#define LOG_TAG "NatController"
#include <android-base/stringprintf.h>
#include <cutils/log.h>
#include <logwrap/logwrap.h>

#include "NetdConstants.h"
#include "NatController.h"
#include "NetdConstants.h"
#include "RouteController.h"

using android::base::StringPrintf;

const char* NatController::LOCAL_FORWARD = "natctrl_FORWARD";
const char* NatController::LOCAL_MANGLE_FORWARD = "natctrl_mangle_FORWARD";
const char* NatController::LOCAL_NAT_POSTROUTING = "natctrl_nat_POSTROUTING";
const char* NatController::LOCAL_RAW_PREROUTING = "natctrl_raw_PREROUTING";
const char* NatController::LOCAL_TETHER_COUNTERS_CHAIN = "natctrl_tether_counters";

auto NatController::execFunction = android_fork_execvp;
auto NatController::iptablesRestoreFunction = execIptablesRestore;

NatController::NatController() {
}

NatController::~NatController() {
}

struct CommandsAndArgs {
    /* The array size doesn't really matter as the compiler will barf if too many initializers are specified. */
    const char *cmd[32];
    bool checkRes;
};

int NatController::runCmd(int argc, const char **argv) {
    int res;

    res = execFunction(argc, (char **)argv, NULL, false, false);

#if !LOG_NDEBUG
    std::string full_cmd = argv[0];
    argc--; argv++;
    /*
     * HACK: Sometimes runCmd() is called with a ridcously large value (32)
     * and it works because the argv[] contains a NULL after the last
     * true argv. So here we use the NULL argv[] to terminate when the argc
     * is horribly wrong, and argc for the normal cases.
     */
    for (; argc && argv[0]; argc--, argv++) {
        full_cmd += " ";
        full_cmd += argv[0];
    }
    ALOGV("runCmd(%s) res=%d", full_cmd.c_str(), res);
#endif
    return res;
}

int NatController::setupIptablesHooks() {
    int res;
    res = setDefaults();
    if (res < 0) {
        return res;
    }

    // Used to limit downstream mss to the upstream pmtu so we don't end up fragmenting every large
    // packet tethered devices send. This is IPv4-only, because in IPv6 we send the MTU in the RA.
    // This is no longer optional and tethering will fail to start if it fails.
    std::string mssRewriteCommand = StringPrintf(
        "*mangle\n"
        "-A %s -p tcp --tcp-flags SYN SYN -j TCPMSS --clamp-mss-to-pmtu\n"
        "COMMIT\n", LOCAL_MANGLE_FORWARD);

    // This is for tethering counters. This chain is reached via --goto, and then RETURNS.
    std::string defaultCommands = StringPrintf(
        "*filter\n"
        ":%s -\n"
        "COMMIT\n", LOCAL_TETHER_COUNTERS_CHAIN);

    res = iptablesRestoreFunction(V4, mssRewriteCommand);
    if (res < 0) {
        return res;
    }

    res = iptablesRestoreFunction(V4V6, defaultCommands);
    if (res < 0) {
        return res;
    }

    ifacePairList.clear();

    return 0;
}

int NatController::setDefaults() {
    std::string v4Cmd = StringPrintf(
        "*filter\n"
        ":%s -\n"
        "-A %s -j DROP\n"
        "COMMIT\n"
        "*nat\n"
        ":%s -\n"
        "COMMIT\n", LOCAL_FORWARD, LOCAL_FORWARD, LOCAL_NAT_POSTROUTING);

    std::string v6Cmd = StringPrintf(
        "*filter\n"
        ":%s -\n"
        "COMMIT\n"
        "*raw\n"
        ":%s -\n"
        "COMMIT\n", LOCAL_FORWARD, LOCAL_RAW_PREROUTING);

    int res = iptablesRestoreFunction(V4, v4Cmd);
    if (res < 0) {
        return res;
    }

    res = iptablesRestoreFunction(V6, v6Cmd);
    if (res < 0) {
        return res;
    }

    natCount = 0;

    return 0;
}

int NatController::enableNat(const char* intIface, const char* extIface) {
    ALOGV("enableNat(intIface=<%s>, extIface=<%s>)",intIface, extIface);

    if (!isIfaceName(intIface) || !isIfaceName(extIface)) {
        errno = ENODEV;
        return -1;
    }

    /* Bug: b/9565268. "enableNat wlan0 wlan0". For now we fail until java-land is fixed */
    if (!strcmp(intIface, extIface)) {
        ALOGE("Duplicate interface specified: %s %s", intIface, extIface);
        errno = EINVAL;
        return -1;
    }

    // add this if we are the first added nat
    if (natCount == 0) {
        const char *v4Cmd[] = {
                IPTABLES_PATH,
                "-w",
                "-t",
                "nat",
                "-A",
                LOCAL_NAT_POSTROUTING,
                "-o",
                extIface,
                "-j",
                "MASQUERADE"
        };

        /*
         * IPv6 tethering doesn't need the state-based conntrack rules, so
         * it unconditionally jumps to the tether counters chain all the time.
         */
        const char *v6Cmd[] = {IP6TABLES_PATH, "-w", "-A", LOCAL_FORWARD,
                               "-g", LOCAL_TETHER_COUNTERS_CHAIN};

        if (runCmd(ARRAY_SIZE(v4Cmd), v4Cmd) || runCmd(ARRAY_SIZE(v6Cmd), v6Cmd)) {
            ALOGE("Error setting postroute rule: iface=%s", extIface);
            // unwind what's been done, but don't care about success - what more could we do?
            setDefaults();
            return -1;
        }
    }

    if (setForwardRules(true, intIface, extIface) != 0) {
        ALOGE("Error setting forward rules");
        if (natCount == 0) {
            setDefaults();
        }
        errno = ENODEV;
        return -1;
    }

    /* Always make sure the drop rule is at the end */
    const char *cmd1[] = {
            IPTABLES_PATH,
            "-w",
            "-D",
            LOCAL_FORWARD,
            "-j",
            "DROP"
    };
    runCmd(ARRAY_SIZE(cmd1), cmd1);
    const char *cmd2[] = {
            IPTABLES_PATH,
            "-w",
            "-A",
            LOCAL_FORWARD,
            "-j",
            "DROP"
    };
    runCmd(ARRAY_SIZE(cmd2), cmd2);

    natCount++;
    return 0;
}

bool NatController::checkTetherCountingRuleExist(const char *pair_name) {
    std::list<std::string>::iterator it;

    for (it = ifacePairList.begin(); it != ifacePairList.end(); it++) {
        if (*it == pair_name) {
            /* We already have this counter */
            return true;
        }
    }
    return false;
}

int NatController::setTetherCountingRules(bool add, const char *intIface, const char *extIface) {

    /* We only ever add tethering quota rules so that they stick. */
    if (!add) {
        return 0;
    }
    char *pair_name;
    asprintf(&pair_name, "%s_%s", intIface, extIface);

    if (checkTetherCountingRuleExist(pair_name)) {
        free(pair_name);
        return 0;
    }
    const char *cmd2b[] = {
        IPTABLES_PATH,
        "-w", "-A", LOCAL_TETHER_COUNTERS_CHAIN, "-i", intIface, "-o", extIface, "-j", "RETURN"
    };

    const char *cmd2c[] = {
        IP6TABLES_PATH,
        "-w", "-A", LOCAL_TETHER_COUNTERS_CHAIN, "-i", intIface, "-o", extIface, "-j", "RETURN"
    };

    if (runCmd(ARRAY_SIZE(cmd2b), cmd2b) || runCmd(ARRAY_SIZE(cmd2c), cmd2c)) {
        free(pair_name);
        return -1;
    }
    ifacePairList.push_front(pair_name);
    free(pair_name);

    asprintf(&pair_name, "%s_%s", extIface, intIface);
    if (checkTetherCountingRuleExist(pair_name)) {
        free(pair_name);
        return 0;
    }

    const char *cmd3b[] = {
        IPTABLES_PATH,
        "-w", "-A", LOCAL_TETHER_COUNTERS_CHAIN, "-i", extIface, "-o", intIface, "-j", "RETURN"
    };

    const char *cmd3c[] = {
        IP6TABLES_PATH,
        "-w", "-A", LOCAL_TETHER_COUNTERS_CHAIN, "-i", extIface, "-o", intIface, "-j", "RETURN"
    };

    if (runCmd(ARRAY_SIZE(cmd3b), cmd3b) || runCmd(ARRAY_SIZE(cmd3c), cmd3c)) {
        // unwind what's been done, but don't care about success - what more could we do?
        free(pair_name);
        return -1;
    }
    ifacePairList.push_front(pair_name);
    free(pair_name);
    return 0;
}

int NatController::setForwardRules(bool add, const char *intIface, const char *extIface) {
    const char *cmd1[] = {
            IPTABLES_PATH,
            "-w",
            add ? "-A" : "-D",
            LOCAL_FORWARD,
            "-i",
            extIface,
            "-o",
            intIface,
            "-m",
            "state",
            "--state",
            "ESTABLISHED,RELATED",
            "-g",
            LOCAL_TETHER_COUNTERS_CHAIN
    };
    int rc = 0;

    if (runCmd(ARRAY_SIZE(cmd1), cmd1) && add) {
        return -1;
    }

    const char *cmd2[] = {
            IPTABLES_PATH,
            "-w",
            add ? "-A" : "-D",
            LOCAL_FORWARD,
            "-i",
            intIface,
            "-o",
            extIface,
            "-m",
            "state",
            "--state",
            "INVALID",
            "-j",
            "DROP"
    };

    const char *cmd3[] = {
            IPTABLES_PATH,
            "-w",
            add ? "-A" : "-D",
            LOCAL_FORWARD,
            "-i",
            intIface,
            "-o",
            extIface,
            "-g",
            LOCAL_TETHER_COUNTERS_CHAIN
    };

    const char *cmd4[] = {
            IP6TABLES_PATH,
            "-w",
            "-t",
            "raw",
            add ? "-A" : "-D",
            LOCAL_RAW_PREROUTING,
            "-i",
            intIface,
            "-m",
            "rpfilter",
            "--invert",
            "!",
            "-s",
            "fe80::/64",
            "-j",
            "DROP"
    };

    if (runCmd(ARRAY_SIZE(cmd2), cmd2) && add) {
        // bail on error, but only if adding
        rc = -1;
        goto err_invalid_drop;
    }

    if (runCmd(ARRAY_SIZE(cmd3), cmd3) && add) {
        // unwind what's been done, but don't care about success - what more could we do?
        rc = -1;
        goto err_return;
    }

    if (runCmd(ARRAY_SIZE(cmd4), cmd4) && add) {
        rc = -1;
        goto err_rpfilter;
    }

    if (setTetherCountingRules(add, intIface, extIface) && add) {
        rc = -1;
        goto err_return;
    }

    return 0;

err_rpfilter:
    cmd3[2] = "-D";
    runCmd(ARRAY_SIZE(cmd3), cmd3);
err_return:
    cmd2[2] = "-D";
    runCmd(ARRAY_SIZE(cmd2), cmd2);
err_invalid_drop:
    cmd1[2] = "-D";
    runCmd(ARRAY_SIZE(cmd1), cmd1);
    return rc;
}

int NatController::disableNat(const char* intIface, const char* extIface) {
    if (!isIfaceName(intIface) || !isIfaceName(extIface)) {
        errno = ENODEV;
        return -1;
    }

    setForwardRules(false, intIface, extIface);
    if (--natCount <= 0) {
        // handle decrement to 0 case (do reset to defaults) and erroneous dec below 0
        setDefaults();
    }
    return 0;
}
