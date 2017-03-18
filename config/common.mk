PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Generic overrides / AOSP fixes
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
    ro.com.android.dataroaming=false \
    ro.com.google.ime.theme_id=5

# Backup Tool / whitelist
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/du/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/du/prebuilt/common/bin/50-base.sh:system/addon.d/50-base.sh \
    vendor/du/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Init file
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/init.local.rc:root/init.du.rc

# Gesture libs for AOSP LatinIME
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so \
    vendor/du/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so \
    vendor/du/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so \
    vendor/du/prebuilt/common/lib64/libjni_latinimegoogle.so:system/lib64/libjni_latinimegoogle.so

# Filesystem labels
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel \
    vendor/du/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/du/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/du/prebuilt/common/bin/sysinit:system/bin/sysinit

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/mkshrc:system/etc/mkshrc \

# Packages
include vendor/du/config/packages.mk

# Easy way for unofficial builders to add more packages, overrides, etc
-include vendor/extra/product.mk

# Overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/du/overlay/common

# Use specific resolution for bootanimation
ifneq ($(SMALL_BOOTANIMATION_SIZE),)
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/media/res/$(SMALL_BOOTANIMATION_SIZE).zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip
endif

# DU versions / branding
include vendor/du/config/branding.mk
