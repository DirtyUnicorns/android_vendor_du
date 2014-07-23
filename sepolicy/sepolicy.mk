BOARD_SEPOLICY_DIRS += \
    vendor/du/sepolicy

BOARD_SEPOLICY_UNION += \
    file_contexts \
    file.te \
    genfs_contexts \
    installd.te \
    netd.te \
    ueventd.te \
    mac_permissions.xml \
	vold.te
