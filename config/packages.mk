# Packages
PRODUCT_PACKAGES += \
    Basic \
    CellBroadcastReceiver \
    Development \
    DU-About \
    LatinIME \
    OmniJaws \
    OmniStyle \
    OmniSwitch \
    ThemeInterfacer \
    Turbo

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat

# DSP Manager / Music FX
ifneq ($(TARGET_NO_DSPMANAGER), true)
PRODUCT_PACKAGES += \
    libcyanogen-dsp \
    audio_effects.conf
endif

# DU Utils Library
PRODUCT_PACKAGES += \
    org.dirtyunicorns.utils

PRODUCT_BOOT_JARS += \
    org.dirtyunicorns.utils


# Manual provisiong support
ifneq ($(BOARD_USES_QCOM_HARDWARE),true)
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext
endif

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
