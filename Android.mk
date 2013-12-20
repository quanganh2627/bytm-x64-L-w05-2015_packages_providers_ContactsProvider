LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

# Only compile source java files in this apk.
LOCAL_SRC_FILES := $(call all-java-files-under, src)
LOCAL_SRC_FILES += \
        src/com/android/providers/contacts/EventLogTags.logtags

LOCAL_JAVA_LIBRARIES := ext telephony-common
LOCAL_JAVA_LIBRARIES += com.intel.config

LOCAL_STATIC_JAVA_LIBRARIES += android-common com.android.vcard guava

# The Emma tool analyzes code coverage when running unit tests on the
# application. This configuration line selects which packages will be analyzed,
# leaving out code which is tested by other means (e.g. static libraries) that
# would dilute the coverage results. These options do not affect regular
# production builds.
LOCAL_EMMA_COVERAGE_FILTER := +com.android.providers.contacts.*

# The Emma tool analyzes code coverage when running unit tests on the
# application. This configuration line selects which packages will be analyzed,
# leaving out code which is tested by other means (e.g. static libraries) that
# would dilute the coverage results. These options do not affect regular
# production builds.
LOCAL_EMMA_COVERAGE_FILTER := +com.android.providers.contacts.*

LOCAL_PACKAGE_NAME := ContactsProvider
LOCAL_CERTIFICATE := shared

ifeq ($(strip $(INTEL_FEATURE_ARKHAM)),true)
ARKHAM_DIR := vendor/intel/PRIVATE/arkham/aosp/$(LOCAL_PATH)/enabled
LOCAL_MODULE := $(LOCAL_PACKAGE_NAME)
LOCAL_MODULE_CLASS := APPS
intermediates := $(call local-intermediates-dir)
ARKHAM_MANIFEST := $(addprefix $(intermediates)/,AndroidManifest.xml)
LOCAL_GENERATED_SOURCES := $(ARKHAM_MANIFEST)
LOCAL_FULL_MANIFEST_FILE := $(ARKHAM_MANIFEST)
LOCAL_MODULE :=
LOCAL_MODULE_CLASS :=
MANIFEST_SOURCE := $(ANDROID_BUILD_TOP)/$(LOCAL_PATH)/AndroidManifest.xml
$(ARKHAM_MANIFEST) : PRIVATE_CUSTOM_TOOL := sed -f $(ARKHAM_DIR)/AndroidManifest.sed $(MANIFEST_SOURCE) > $(ARKHAM_MANIFEST)
$(ARKHAM_MANIFEST) : PRIVATE_TOP := $(ANDROID_BUILD_TOP)
$(ARKHAM_MANIFEST) : $(ARKHAM_DIR)/AndroidManifest.sed $(MANIFEST_SOURCE)
	$(transform-generated-source)
LOCAL_SRC_FILES += $(call all-java-files-under, ../../../$(ARKHAM_DIR)/src)
else
ARKHAM_DIR := vendor/intel/arkham/$(LOCAL_PATH)/disabled
LOCAL_SRC_FILES += $(call all-java-files-under, ../../../$(ARKHAM_DIR)/src)
endif

LOCAL_PRIVILEGED_MODULE := true

LOCAL_PROGUARD_FLAG_FILES := proguard.flags

include $(BUILD_PACKAGE)

# Use the following include to make our test apk.
include $(call all-makefiles-under,$(LOCAL_PATH))
