#!/bin/bash
#
# Copyright (C) 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set up prog to be the path of this script, including following symlinks,
# and set up progdir to be the fully-qualified pathname of its directory.
prog="$0"
args="$@"
while [ -h "${prog}" ]; do
  newProg=`/bin/ls -ld "${prog}"`
  newProg=`expr "${newProg}" : ".* -> \(.*\)$"`
  if expr "x${newProg}" : 'x/' >/dev/null; then
      prog="${newProg}"
  else
    progdir=`dirname "${prog}"`
    prog="${progdir}/${newProg}"
  fi
done
oldwd=`pwd`
progdir=`dirname "${prog}"`
cd "${progdir}"
progdir=`pwd`
prog="${progdir}"/`basename "${prog}"`
test_dir="test-$$"
if [ -z "$TMPDIR" ]; then
  tmp_dir="/tmp/$USER/${test_dir}"
else
  tmp_dir="${TMPDIR}/${test_dir}"
fi

if [ "x$ANDROID_BUILD_TOP" = "x" ]; then
  echo Build environment is not set-up.
  exit -1
fi

# This only works internally for now (sorry folks!)
jack_annotations_lib=/google/data/rw/teams/android-runtime/jack/jack-test-annotations-lib.jack
if [ ! -f $jack_annotations_lib ]; then
  echo Try 'prodaccess' to access android-runtime directory.
  exit -1
fi

# Compile test into a base64 string that can be instantiated via
# reflection on hosts without the jack-test-annotations-lib.jack file.
mkdir $tmp_dir
for input_file in $progdir/*.java; do
  i=${input_file##*/Test}
  i=${i%%.java}
  src_file=$progdir/Test$i.java
  jack_file=./src.jack
  dex_file=./classes.dex
  base_64_file=$tmp_dir/TestData$i.base64
  output_file=$progdir/../src/TestData$i.java
  # Compile source file to jack file.
  jack -g -cp $ANDROID_BUILD_TOP/out/host/linux-x86/../common/obj/JAVA_LIBRARIES/core-libart-hostdex_intermediates/classes.jack:$ANDROID_BUILD_TOP/out/host/linux-x86/../common/obj/JAVA_LIBRARIES/core-oj-hostdex_intermediates/classes.jack:$jack_annotations_lib -D sched.runner=multi-threaded -D sched.runner.thread.kind=fixed -D sched.runner.thread.fixed.count=4 -D jack.java.source.version=1.7 -D jack.android.min-api-level=o-b2 --output-jack $jack_file $src_file
  # Compile jack file to classes.dex.
  jack -g -cp $ANDROID_BUILD_TOP/out/host/linux-x86/../common/obj/JAVA_LIBRARIES/core-libart-hostdex_intermediates/classes.jack:$ANDROID_BUILD_TOP/out/host/linux-x86/../common/obj/JAVA_LIBRARIES/core-oj-hostdex_intermediates/classes.jack -D sched.runner=multi-threaded -D sched.runner.thread.kind=fixed -D sched.runner.thread.fixed.count=4 -D jack.java.source.version=1.7 -D jack.android.min-api-level=o-b2 --import $jack_file --output-dex .
  # Pack the classes.dex file into a base64 string.
  base64 -w 72 $dex_file > $base_64_file
  # Emit a managed source file containing the base64 string. The test can be
  # run by loading this string as a dex file and invoking it via reflection.
cat > $output_file <<HEADER
/* Generated by ${prog##*/} from ${src_file##*/} */
public class TestData$i {
  public static final String BASE64_DEX_FILE =
HEADER
sed -e 's/^\(.*\)$/    "\1" +/' -e '$s/ +/;/' $base_64_file >> $output_file
cat >> $output_file <<FOOTER
}
FOOTER
  rm $dex_file $jack_file
done

rm -rf $tmp_dir
