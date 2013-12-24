PRODUCT_BRAND ?= du

# bootanimations
PRODUCT_COPY_FILES += \
	vendor/du/bootanimations/bootanimation.zip:system/media/bootanimation.zip

# general properties
PRODUCT_PROPERTY_OVERRIDES += \
	keyguard.no_require_sim=true \
	ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
	ro.com.google.clientidbase=android-google \
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

# Koush Superuser
SUPERUSER_EMBEDDED := true

PRODUCT_PACKAGES += \
    Superuser \
    su

PRODUCT_COPY_FILES += \
    external/koush/Superuser/init.superuser.rc:root/init.superuser.rc \
    vendor/du/proprietary/Term/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so
    
#DUStats
PRODUCT_PROPERTY_OVERRIDES += \
ro.romstats.url=http://stats.dirtyunicorns.com/ \
ro.romstats.name=DirtyUnicorns \
ro.romstats.version=testing \
ro.romstats.tframe=3

