TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

  TARGET_BOOTLOADER_CONFIG += imx8mm:smarcimx8mm_4g_ser3_android_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8mm-dual:smarcimx8mm_4g_ser3_android_dual_defconfig
ifeq ($(PRODUCT_IMX_TRUSTY),true)
  TARGET_BOOTLOADER_CONFIG += imx8mm-trusty-secure-unlock-dual:smarcimx8mm_4g_ser3_android_trusty_secure_unlock_dual_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8mm-trusty-dual:smarcimx8mm_4g_ser3_android_trusty_dual_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8mm-trusty-rbidx-blob-dual:smarcimx8mm_4g_ser3_android_trusty_rbidx_blob_dual_defconfig
endif

# u-boot target used by uuu for smarc-imx8mm with LPDDR4 on board
TARGET_BOOTLOADER_CONFIG += imx8mm-smarc-uuu:smarcimx8mm_4g_ser3_android_uuu_defconfig

# imx8mm kernel defconfig
TARGET_KERNEL_DEFCONFIG := gki_defconfig
ifeq ($(LOADABLE_KERNEL_MODULE),true)
TARGET_KERNEL_GKI_DEFCONF:= imx8mm_gki.fragment
else
TARGET_KERNEL_GKI_DEFCONF := imx_v8_android_defconfig
endif
TARGET_KERNEL_ADDITION_DEFCONF := android_addition_defconfig

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0

