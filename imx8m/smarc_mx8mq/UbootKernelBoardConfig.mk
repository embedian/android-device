TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

TARGET_BOOTLOADER_CONFIG := \
	imx8mq-smarc_2g:smarcimx8mq_2g_ser3_android_defconfig \
	imx8mq-smarc_4g:smarcimx8mq_4g_ser3_android_defconfig \
	imx8mq-dual-smarc_2g:smarcimx8mq_2g_ser3_android_dual_defconfig \
	imx8mq-dual-smarc_4g:smarcimx8mq_4g_ser3_android_dual_defconfig \
	imx8mq-smarc_2g-uuu:smarcimx8mq_2g_ser3_android_uuu_defconfig \
	imx8mq-smarc_4g-uuu:smarcimx8mq_4g_ser3_android_uuu_defconfig

ifeq ($(PRODUCT_IMX_TRUSTY),true)
  TARGET_BOOTLOADER_CONFIG += \
	imx8mq-trusty-smarc_2g:smarcimx8mq_2g_ser3_android_trusty_defconfig \
	imx8mq-trusty-smarc_4g:smarcimx8mq_4g_ser3_android_trusty_defconfig
  TARGET_BOOTLOADER_CONFIG += \
        imx8mq-trusty-secure-unlock-smarc_2g:smarcimx8mq_2g_ser3_android_trusty_secure_unlock_defconfig \
        imx8mq-trusty-secure-unlock-smarc_4g:smarcimx8mq_4g_ser3_android_trusty_secure_unlock_defconfig
  TARGET_BOOTLOADER_CONFIG += \
	imx8mq-trusty-dual-smarc_2g:smarcimx8mq_2g_ser3_android_trusty_dual_defconfig \
	imx8mq-trusty-dual-smarc_4g:smarcimx8mq_4g_ser3_android_trusty_dual_defconfig
endif

# imx8mq kernel defconfig
TARGET_KERNEL_DEFCONFIG := imx_v8_android_defconfig
TARGET_KERNEL_ADDITION_DEFCONF := android_addition_defconfig

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0

