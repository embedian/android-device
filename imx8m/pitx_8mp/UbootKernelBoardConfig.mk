# from BoardConfig.mk
TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

# u-boot target
TARGET_BOOTLOADER_CONFIG := imx8mp:pitximx8mp_4g_android_defconfig
TARGET_BOOTLOADER_CONFIG += imx8mp-dual:pitximx8mp_4g_android_dual_defconfig
ifeq ($(PRODUCT_IMX_TRUSTY),true)
TARGET_BOOTLOADER_CONFIG += imx8mp-trusty-secure-unlock-dual:pitximx8mp_4g_android_trusty_secure_unlock_dual_defconfig
TARGET_BOOTLOADER_CONFIG += imx8mp-trusty-dual:pitximx8mp_4g_android_trusty_dual_defconfig
TARGET_BOOTLOADER_CONFIG += imx8mp-trusty-rbidx-blob-dual:pitximx8mp_4g_android_trusty_rbidx_blob_dual_defconfig
endif
TARGET_BOOTLOADER_CONFIG += imx8mp-pitx-uuu:pitximx8mp_4g_android_uuu_defconfig

TARGET_KERNEL_DEFCONFIG := gki_defconfig
ifeq ($(LOADABLE_KERNEL_MODULE),true)
TARGET_KERNEL_GKI_DEFCONF:= imx8mp_gki.fragment
else
TARGET_KERNEL_GKI_DEFCONF := imx_v8_android_defconfig
endif

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0

