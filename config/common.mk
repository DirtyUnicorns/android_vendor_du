PRODUCT_BRAND ?= du

# bootanimations
PRODUCT_COPY_FILES += \
	vendor/du/bootanimations/bootanimation.zip:system/media/bootanimation.zip

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# general properties
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    persist.sys.root_access=1

# enable ADB authentication if not on eng build
ifneq ($(TARGET_BUILD_VARIANT),eng)
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/du/prebuilt/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/du/prebuilt/bin/50-hosts.sh:system/addon.d/50-hosts.sh \
    vendor/du/prebuilt/bin/blacklist:system/addon.d/blacklist

# init.d support
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/bin/sysinit:system/bin/sysinit \
    vendor/du/prebuilt/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/du/prebuilt/etc/init.d/00check:system/etc/init.d/00check \
    vendor/du/prebuilt/etc/init.d/01zipalign:system/etc/init.d/01zipalign \
    vendor/du/prebuilt/etc/init.d/02sysctl:system/etc/init.d/02sysctl \
    vendor/du/prebuilt/etc/init.d/03firstboot:system/etc/init.d/03firstboot \
    vendor/du/prebuilt/etc/init.d/05freemem:system/etc/init.d/05freemem \
    vendor/du/prebuilt/etc/init.d/06removecache:system/etc/init.d/06removecache \
    vendor/du/prebuilt/etc/init.d/07fixperms:system/etc/init.d/07fixperms \
    vendor/du/prebuilt/etc/init.d/09cron:system/etc/init.d/09cron \
    vendor/du/prebuilt/etc/init.d/10sdboost:system/etc/init.d/10sdboost \
    vendor/du/prebuilt/etc/init.d/11battery:system/etc/init.d/11battery \
    vendor/du/prebuilt/etc/init.d/12touch:system/etc/init.d/12touch \
    vendor/du/prebuilt/etc/init.d/13minfree:system/etc/init.d/13minfree \
    vendor/du/prebuilt/etc/init.d/14gpurender:system/etc/init.d/14gpurender \
    vendor/du/prebuilt/etc/init.d/15sleepers:system/etc/init.d/15sleepers \
    vendor/du/prebuilt/etc/init.d/16journalism:system/etc/init.d/16journalism \
    vendor/du/prebuilt/etc/init.d/17sqlite3:system/etc/init.d/17sqlite3 \
    vendor/du/prebuilt/etc/init.d/18wifisleep:system/etc/init.d/18wifisleep \
    vendor/du/prebuilt/etc/init.d/19iostats:system/etc/init.d/19iostats \
    vendor/du/prebuilt/etc/init.d/20setrenice:system/etc/init.d/20setrenice \
    vendor/du/prebuilt/etc/init.d/21tweaks:system/etc/init.d/21tweaks \
    vendor/du/prebuilt/etc/init.d/24speedy_modified:system/etc/init.d/24speedy_modified \
    vendor/du/prebuilt/etc/init.d/25loopy_smoothness_tweak:system/etc/init.d/25loopy_smoothness_tweak \
    vendor/du/prebuilt/etc/init.d/98tweaks:system/etc/init.d/98tweaks \
    vendor/du/prebuilt/etc/helpers.sh:system/etc/helpers.sh \
    vendor/du/prebuilt/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/du/prebuilt/etc/init.d.cfg:system/etc/init.d.cfg

# userinit support
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/etc/init.d/90userinit:system/etc/init.d/90userinit

# Init script file with DU extras
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/etc/init.local.rc:root/init.du.rc

# Enable SIP and VoIP on all targets
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Additional packages
-include vendor/du/config/packages.mk

# Versioning
-include vendor/du/config/version.mk

# Add our overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/du/overlay/common

# SU Support
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/bin/su:system/xbin/daemonsu \
    vendor/du/prebuilt/bin/su:system/xbin/su \
    vendor/du/prebuilt/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon \
    vendor/du/prebuilt/apk/Superuser.apk:system/app/Superuser.apk
    
# HFM Files
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/etc/hosts.alt:system/etc/hosts.alt \
    vendor/du/prebuilt/etc/hosts.og:system/etc/hosts.og

#DUStats
PRODUCT_PROPERTY_OVERRIDES += \
ro.romstats.url=http://stats.dirtyunicorns.com/ \
ro.romstats.name=DirtyUnicorns \
ro.romstats.version=7.1 \
ro.romstats.tframe=3

