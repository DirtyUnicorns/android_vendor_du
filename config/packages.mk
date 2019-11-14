# Packages
PRODUCT_PACKAGES += \
    LatinIMEGooglePrebuilt \
    SoundPickerPrebuilt \
    WallpaperPicker2
#    CustomDoze \
#    WeatherClient

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni
