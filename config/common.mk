PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/bin/sysinit:system/bin/sysinit \
    vendor/du/prebuilt/etc/init.du.rc:root/init.du.rc

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    dalvik.vm.debug.alloc=0 \
    ro.config.alarm_alert=Oxygen.ogg \
    ro.config.ringtone=Orion.ogg \
    ro.config.notification_sound=Tethys.ogg \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.build.selinux=1 \
    ro.com.android.dataroaming=false

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/du/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/du/prebuilt/common/bin/50-base.sh:system/addon.d/50-base.sh \

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/du/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Init file
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/init.local.rc:root/init.du.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/mkshrc:system/etc/mkshrc \

PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/du/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/du/prebuilt/common/bin/sysinit:system/bin/sysinit

# Stagefright FFMPEG plugin
ifneq ($(BOARD_USES_QCOM_HARDWARE),true)
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so
endif

# Packages
include vendor/du/config/packages.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/du/overlay/common

# Boot Animation
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip

# SuperSU
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/du/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# Versioning System
ANDROID_VERSION = 7.0
DU_VERSION = v11.0
ifndef DU_BUILD_TYPE
    DU_BUILD_TYPE := DIRTY-DEEDS
    PLATFORM_VERSION_CODENAME := DIRTY-DEEDS
endif

#Build DU-Updater only if DU_BUILD_TYPE isn't DIRTY-DEEDS
ifneq ($(DU_BUILD_TYPE),DIRTY-DEEDS)
PRODUCT_PACKAGES += \
    DU-Updater
endif

# easy way to extend to add more packages
-include vendor/extra/product.mk

# Set all versions
DU_VERSION := DU_$(DU_BUILD)_$(ANDROID_VERSION)_$(shell date -u +%Y%m%d-%H%M).$(DU_VERSION)-$(DU_BUILD_TYPE)
DU_MOD_VERSION := DU_$(DU_BUILD)_$(ANDROID_VERSION)_$(shell date -u +%Y%m%d-%H%M).$(DU_VERSION)-$(DU_BUILD_TYPE)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.du.version=$(DU_VERSION) \
    ro.mod.version=$(DU_BUILD_TYPE)-v11.0

