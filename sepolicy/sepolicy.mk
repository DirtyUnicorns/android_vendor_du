BOARD_SEPOLICY_DIRS += \
    vendor/du/sepolicy

BOARD_SEPOLICY_UNION += \
    file.te \
    file_contexts \
    genfs_contexts \
    property_contexts \
    seapp_contexts \
    auditd.te \
    healthd.te \
    hostapd.te \
    installd.te \
    mediaserver.te \
    netd.te \
    property.te \
    recovery.te \
    shell.te \
    su.te \
    sysinit.te \
    system.te \
    ueventd.te \
    vold.te \
    mac_permissions.xml
