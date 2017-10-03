# Versioning System
DU_BASE_VERSION = v11.7.2

ifndef DU_BUILD_TYPE
    DU_BUILD_TYPE := UNOFFICIAL
endif

# Only include DU-Updater for official, weeklies, and rc builds
ifeq ($(filter-out OFFICIAL WEEKLIES RC,$(DU_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        DU-Updater
endif

# Sign builds if building an official or weekly build
ifeq ($(filter-out OFFICIAL WEEKLIES,$(DU_BUILD_TYPE)),)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := ../.keys/releasekey
endif

# Set all versions
DU_VERSION := $(TARGET_PRODUCT)-$(DU_BASE_VERSION)-$(shell date -u +%Y%m%d-%H%M)-$(DU_BUILD_TYPE)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.du.version=$(DU_VERSION) \
    ro.mod.version=$(DU_BUILD_TYPE)-$(DU_BASE_VERSION)
