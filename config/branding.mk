# Versioning System
ANDROID_VERSION = 7.1.2
DU_VERSION = v11.4
ifndef DU_BUILD_TYPE
    DU_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
endif

# Build DU-Updater for only official, rc and weeklies
ifeq ($(DU_BUILD_TYPE),OFFICIAL)
    PRODUCT_PACKAGES += \
        DU-Updater
endif
ifeq ($(DU_BUILD_TYPE),WEEKLIES)
    PRODUCT_PACKAGES += \
        DU-Updater
endif
ifeq ($(DU_BUILD_TYPE),RC)
    PRODUCT_PACKAGES += \
        DU-Updater
endif

# Use signing keys for only official and weeklies
ifeq ($(DU_BUILD_TYPE),OFFICIAL)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := ../.keys/releasekey
endif
ifeq ($(DU_BUILD_TYPE),WEEKLIES)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := ../.keys/releasekey
endif

# Set all versions
DU_VERSION := DU_$(DU_BUILD)_$(ANDROID_VERSION)_$(shell date -u +%Y%m%d-%H%M).$(DU_VERSION)-$(DU_BUILD_TYPE)
DU_MOD_VERSION := DU_$(DU_BUILD)_$(ANDROID_VERSION)_$(shell date -u +%Y%m%d-%H%M).$(DU_VERSION)-$(DU_BUILD_TYPE)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.du.version=$(DU_VERSION) \
    ro.mod.version=$(DU_BUILD_TYPE)-v11.4

