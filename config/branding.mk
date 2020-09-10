# Versioning System
DU_BASE_VERSION = v14.7

ifndef DU_BUILD_TYPE
    DU_BUILD_TYPE := UNOFFICIAL
endif

# Only include DU-Updater for official, weeklies, and rc builds
ifeq ($(filter-out OFFICIAL WEEKLIES RC,$(DU_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        DU-Updater
endif

# Only include DU Notifier for official and weeklies
ifeq ($(filter-out OFFICIAL WEEKLIES,$(DU_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        DuNotifierPrebuilt
endif

# Sign builds if building an official or weekly build
ifeq ($(filter-out OFFICIAL WEEKLIES,$(DU_BUILD_TYPE)),)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := $(KEYS_LOCATION)
endif

# Set all versions
BUILD_DATE := $(shell date -u +%Y%m%d)
BUILD_TIME := $(shell date -u +%H%M)
DU_VERSION := $(TARGET_PRODUCT)-$(DU_BASE_VERSION)-$(BUILD_DATE)-$(BUILD_TIME)-$(DU_BUILD_TYPE)
TARGET_BACON_NAME := $(DU_VERSION)
ROM_FINGERPRINT := DirtyUnicorns/$(PLATFORM_VERSION)/$(DU_BUILD_TYPE)/$(BUILD_DATE)$(BUILD_TIME)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.du.version=$(DU_VERSION) \
    ro.mod.version=$(DU_BUILD_TYPE)-$(DU_BASE_VERSION)-$(BUILD_DATE) \
    ro.du.fingerprint=$(ROM_FINGERPRINT)
