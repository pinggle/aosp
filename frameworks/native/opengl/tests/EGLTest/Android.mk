# Build the unit tests.
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk

LOCAL_MODULE := EGL_test

LOCAL_MODULE_TAGS := tests

LOCAL_SRC_FILES := \
    egl_cache_test.cpp \
    EGL_test.cpp \

LOCAL_SHARED_LIBRARIES := \
	android.hardware.configstore@1.0 \
	android.hardware.configstore-utils \
	libEGL \
	libcutils \
	libbinder \
	libhidlbase \
	libhidltransport \
	libutils \
	libgui \
	libbase \
	liblog \

LOCAL_C_INCLUDES := \
    bionic/libc/private \
    frameworks/native/opengl/libs \
    frameworks/native/opengl/libs/EGL \

# gold in binutils 2.22 will warn about the usage of mktemp
LOCAL_LDFLAGS += -Wl,--no-fatal-warnings

include $(BUILD_NATIVE_TEST)

# Include subdirectory makefiles
# ============================================================

# If we're building with ONE_SHOT_MAKEFILE (mm, mmm), then what the framework
# team really wants is to build the stuff defined by this makefile.
ifeq (,$(ONE_SHOT_MAKEFILE))
include $(call first-makefiles-under,$(LOCAL_PATH))
endif
