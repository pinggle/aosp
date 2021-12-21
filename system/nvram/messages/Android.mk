#
# Copyright (C) 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := libnvram-messages
LOCAL_SRC_FILES := \
	blob.cpp \
	io.cpp \
	message_codec.cpp \
	nvram_messages.cpp
LOCAL_CFLAGS := -Wall -Werror -Wextra -fvisibility=hidden
LOCAL_CLANG := true
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/include
LOCAL_STATIC_LIBRARIES := libbase
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libnvram-messages-host
LOCAL_SRC_FILES := \
	blob.cpp \
	io.cpp \
	message_codec.cpp \
	nvram_messages.cpp
LOCAL_CFLAGS := -Wall -Werror -Wextra -fvisibility=hidden
LOCAL_CLANG := true
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/include
LOCAL_STATIC_LIBRARIES := libbase
include $(BUILD_HOST_SHARED_LIBRARY)

include $(call all-makefiles-under,$(LOCAL_PATH))
