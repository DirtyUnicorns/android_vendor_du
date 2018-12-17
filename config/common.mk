PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# General additions
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dataroaming=false \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.com.android.dateformat=MM-dd-yyyy \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0 \
    ro.setupwizard.rotation_locked=true \
    ro.build.selinux=1

# Allow tethering without provisioning app
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    net.tethering.noprovisioning=true

PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/du/prebuilt/common/bin/sysinit:system/bin/sysinit

# Init files
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/init.local.rc:system/etc/init/dirtyunicorns.rc

# LatinIME gesture typing
ifneq ($(filter tenderloin,$(TARGET_PRODUCT)),)
ifneq ($(filter shamu,$(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so \
    vendor/du/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so \
    vendor/du/prebuilt/common/lib64/libjni_latinimegoogle.so:system/lib64/libjni_latinimegoogle.so
endif
endif

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/etc/mkshrc:system/etc/mkshrc

# Backup tool
PRODUCT_COPY_FILES += \
    vendor/extras/build/tools/backuptool.sh:install/bin/backuptool.sh \
    vendor/extras/build/tools/backuptool.functions:install/bin/backuptool.functions \
    vendor/extras/build/tools/50-du.sh:system/addon.d/50-du.sh

# Weather client
PRODUCT_COPY_FILES += \
    vendor/du/etc/permissions/org.pixelexperience.weather.client.xml:system/etc/permissions/org.pixelexperience.weather.client.xml \
    vendor/du/etc/default-permissions/org.pixelexperience.weather.client.xml:system/etc/default-permissions/org.pixelexperience.weather.client.xml

# Packages
include vendor/du/config/packages.mk

# Branding
include vendor/du/config/branding.mk

# Themes
include vendor/themes/common.mk

# Overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/du/overlay/common
