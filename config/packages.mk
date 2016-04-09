# DU Utils Library
PRODUCT_PACKAGES += \
    org.dirtyunicorns.utils

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    SpareParts

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    CalendarWidget \
    Chromium \
    DU-About \
    DUCertified \
    LatinIME \
    LockClock \
    OmniSwitch \
    PhaseBeam

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat

# Stagefright FFMPEG plugin
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser
endif
