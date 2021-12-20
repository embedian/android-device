# -------@block_kernel_bootimg-------

KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64

#NXP 8997 wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(TARGET_OUT_INTERMEDIATES)/MXMWIFI_OBJ/mlan.ko \
    $(TARGET_OUT_INTERMEDIATES)/MXMWIFI_OBJ/moal.ko

# -------@block_security-------
#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

