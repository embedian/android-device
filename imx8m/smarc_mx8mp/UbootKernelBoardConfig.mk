# from BoardConfig.mk
TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

# u-boot target
TARGET_BOOTLOADER_CONFIG := \
        imx8mp-smarc_4g:smarcimx8mp_4g_ser3_android_defconfig \
        imx8mp-smarc_6g:smarcimx8mp_6g_ser3_android_defconfig \
	imx8mp-dual-smarc_2g:smarcimx8mp_4g_ser3_android_dual_defconfig \
	imx8mp-dual-smarc_4g:smarcimx8mp_6g_ser3_android_dual_defconfig \
        imx8mp-smarc_4g-uuu:smarcimx8mp_4g_ser3_android_uuu_defconfig \
        imx8mp-smarc_6g-uuu:smarcimx8mp_6g_ser3_android_uuu_defconfig

TARGET_BOOTLOADER_CONFIG += imx8mp-trusty-smarc_4g:smarcimx8mp_4g_ser3_android_trusty_defconfig \
			    imx8mp-trusty-smarc_6g:smarcimx8mp_6g_ser3_android_trusty_defconfig
TARGET_BOOTLOADER_CONFIG += imx8mp-trusty-secure-unlock-smarc_4g:smarcimx8mp_4g_ser3_android_trusty_secure_unlock_defconfig \
			    imx8mp-trusty-secure-unlock-smarc_6g:smarcimx8mp_6g_ser3_android_trusty_secure_unlock_defconfig
  TARGET_BOOTLOADER_CONFIG += \
	imx8mp-trusty-dual-smarc_4g:smarcimx8mp_4g_ser3_android_trusty_dual_defconfig \
	imx8mp-trusty-dual-smarc_6g:smarcimx8mp_6g_ser3_android_trusty_dual_defconfig

ifeq ($(IMX8MP_USES_GKI),true)
TARGET_KERNEL_DEFCONFIG := gki_defconfig
TARGET_KERNEL_GKI_DEFCONF:= android_gki_defconfig
else
TARGET_KERNEL_DEFCONFIG := imx_v8_android_defconfig
endif

TARGET_KERNEL_ADDITION_DEFCONF := android_addition_defconfig


# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0

