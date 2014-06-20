# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

DATE = $(shell vendor/du/tools/getdate)
ANDROID_VERSION = 4.4.4

ifneq ($(DU_BUILD),)
        PRODUCT_PROPERTY_OVERRIDES += \
                ro.du.version=$(TARGET_PRODUCT)_$(ANDROID_VERSION)_$(DATE)
else
        PRODUCT_PROPERTY_OVERRIDES += \
                ro.du.version=$(TARGET_PRODUCT)_$(ANDROID_VERSION)_$(DATE)
endif

