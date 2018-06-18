# Boot Animation
ifeq ($(filter taimen,$(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/media/1440x2880.zip:system/media/bootanimation.zip
endif

ifeq ($(filter  angler marlin shamu,$(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/media/1440x2560.zip:system/media/bootanimation.zip
endif

ifeq ($(filter dumpling,$(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/media/1080x2160.zip:system/media/bootanimation.zip
endif

ifeq ($(filter hammerhead cheeseburger oneplus3 potter,$(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/media/1080x1920.zip:system/media/bootanimation.zip
endif

ifeq ($(filter tenderloin,$(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/media/768x1024.zip:system/media/bootanimation.zip
endif

ifeq ($(filter dragon,$(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/du/prebuilt/common/media/1800x2560.zip:system/media/bootanimation.zip
endif
