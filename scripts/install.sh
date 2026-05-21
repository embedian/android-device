#!/bin/bash
#
# install
#
# This script must be run from the Android main directory.
#
# Embedian patches for Android 15.0.0 1.2.0

set -e
#set -x

SCRIPT_NAME=${0##*/}
readonly SCRIPT_VERSION="0.1"

#### Exports Variables ####
#### global variables ####
readonly ABSOLUTE_FILENAME=$(readlink -e "$0")
readonly ABSOLUTE_DIRECTORY=$(dirname ${ABSOLUTE_FILENAME})
readonly SCRIPT_POINT=${ABSOLUTE_DIRECTORY}
readonly SCRIPT_START_DATE=$(date +%Y%m%d)
readonly ANDROID_DIR="${SCRIPT_POINT}/../../.."
readonly G_CROSS_COMPILER_PATH=${ANDROID_DIR}/prebuilts/gcc/linux-x86/aarch64/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
readonly G_CROSS_COMPILER_ARCHIVE=arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
readonly G_CROSS_COMPILER_LINK=https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel
readonly C_LANG_LINK="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86"
readonly C_LANG_DIR="/opt/prebuilt-android-clang/"
readonly C_LANG_TOOLS_LINK="https://android.googlesource.com/platform/prebuilts/clang-tools"
readonly C_LANG_TOOLS_DIR="/opt/prebuilt-android-clang-tools"
readonly ANDROID_KERNEL_BUILD_TOOLS_LINK="https://android.googlesource.com/kernel/prebuilts/build-tools"
readonly ANDROID_KERNEL_BUILD_TOOLS_DIR="/opt/prebuilt-android-kernel-build-tools"

readonly ANDROID_RUST_LINK="https://android.googlesource.com/platform/prebuilts/rust"

readonly ANDROID_RUST_DIR="/opt/prebuilt-android-rust"

readonly BASE_BRANCH_NAME="android-15.0.0_1.2.0"

## git variables get from base script!
readonly _EXTPARAM_BRANCH="android-15.0.0_1.2.0-emb01"

# Android TAG from release notes
readonly ANDROID_TAG="android-15.0.0_r14"

## dirs ##
readonly EMBEDIAN_PATCHS_DIR="${SCRIPT_POINT}/platform"
readonly EMBEDIAN_SH_DIR="${SCRIPT_POINT}/sh"
VENDOR_BASE_DIR=${ANDROID_DIR}/vendor/embedian
LIBBT=$(readlink -f "${ANDROID_DIR}/hardware/broadcom/libbt")
SEPOLICY=$(readlink -f "${ANDROID_DIR}/system/sepolicy")
BLUETOOTH=$(readlink -f "${ANDROID_DIR}/packages/modules/Bluetooth")

readonly PRE_BUILTS_GCC_PATH=${ANDROID_DIR}/prebuilts/gcc/linux-x86/aarch64/

# print error message
# p1 - printing string
function pr_error() {
	echo ${2} "E: $1"
}

# print warning message
# p1 - printing string
function pr_warning() {
	echo ${2} "W: $1"
}

# print info message
# p1 - printing string
function pr_info() {
	echo ${2} "I: $1"
}

# print debug message
# p1 - printing string
function pr_debug() {
	echo ${2} "D: $1"
}

# test existing brang in git repo
# p1 - git folder
# p2 - branch name
function is_branch_exist()
{
	local D="${1}"
	local B="${2}"
	local B_found
	local HERE

	if [ \( ! -d "${D}" \) -o \( -z "${B}" \) ]; then
		echo false
		return
	fi

	HERE=${PWD}
	cd "${D}" > /dev/null

	# Check branch
	git branch 2>&1 > /dev/null
	if [ ${?} -ne 0 ]; then
		echo false
		cd ${HERE} > /dev/null
		return
	fi
	B_found=$(git branch | grep -w "${B}")
	if [ -z "${B_found}" ]; then
		echo false
	else
		echo true
	fi

	cd ${HERE} > /dev/null
	return
}

############### main code ##############
pr_info "Script version ${SCRIPT_VERSION} (g:20210409)"

cd ${ANDROID_DIR} > /dev/null
pr_info "###########################"
pr_info "# Apply framework patches #"
pr_info "###########################"
cd ${EMBEDIAN_PATCHS_DIR} > /dev/null
git_array=$(find * -type d | grep '.git')
cd - > /dev/null

for _ddd in ${git_array}
do
	_git_p=$(echo ${_ddd} | sed 's/.git//g')
	cd ${ANDROID_DIR}/${_git_p}/ > /dev/null

	if [[ `git branch --list $_EXTPARAM_BRANCH` ]] ; then
		if [[ ${PWD} == ${LIBBT} ]] || [[ ${PWD} == ${BLUETOOTH} ]]; then
			git checkout tags/${ANDROID_TAG}
		else
			git checkout tags/${BASE_BRANCH_NAME}
		fi
		git branch -D ${_EXTPARAM_BRANCH}
		git checkout -b ${_EXTPARAM_BRANCH} || {
			pr_warning "Branch ${_EXTPARAM_BRANCH} is present!"
		};

	else
		git checkout -b ${_EXTPARAM_BRANCH} || {
			pr_warning "Branch ${_EXTPARAM_BRANCH} is present!"
		};
	fi

	pr_info "Apply patches for this git: \"${_git_p}/\""
	git am --whitespace=fix ${EMBEDIAN_PATCHS_DIR}/${_ddd}/*

	cd - > /dev/null
done

pr_info "#######################"
pr_info "# Copy shell utilites #"
pr_info "#######################"
cp -r ${EMBEDIAN_SH_DIR}/* ${ANDROID_DIR}/

pr_info "#######################"
pr_info "# Copy ARM tool chain #"
pr_info "#######################"
# get arm toolchain
(( `ls ${G_CROSS_COMPILER_PATH} 2>/dev/null | wc -l` == 0 )) && {
	pr_info "Get and unpack cross compiler";
	mkdir -p ${ANDROID_DIR}/prebuilts/gcc/linux-x86/aarch64/
	cd ${ANDROID_DIR}/prebuilts/gcc/linux-x86/aarch64/
	wget ${G_CROSS_COMPILER_LINK}/${G_CROSS_COMPILER_ARCHIVE}
	tar -xJf ${G_CROSS_COMPILER_ARCHIVE} \
		-C .
};

pr_info "#######################"
pr_info "# Clang setup         #"
pr_info "#######################"
if [[ ! -d ${C_LANG_DIR} ]] ; then
	sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 ${C_LANG_LINK} ${C_LANG_DIR}
	cd ${C_LANG_DIR}
	sudo git fetch origin 7061673283909f372f4938e45149d23bd10cbd40
	sudo git checkout 7061673283909f372f4938e45149d23bd10cbd40
fi

pr_info "############################"
pr_info "# kernel-build-tools setup #"
pr_info "############################"
if [[ ! -d ${ANDROID_KERNEL_BUILD_TOOLS_DIR} ]] ; then
	sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 ${ANDROID_KERNEL_BUILD_TOOLS_LINK} ${ANDROID_KERNEL_BUILD_TOOLS_DIR}
	cd ${ANDROID_KERNEL_BUILD_TOOLS_DIR}
	sudo git fetch origin b46264b70e3cdf70d08c9ae2df6ea3002b242ebc
	sudo git checkout b46264b70e3cdf70d08c9ae2df6ea3002b242ebc
fi

pr_info "#######################"
pr_info "# Clang tools setup         #"
pr_info "#######################"
if [[ ! -d ${C_LANG_TOOLS_DIR} ]] ; then
        sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 ${C_LANG_TOOLS_LINK} ${C_LANG_TOOLS_DIR}
        cd ${C_LANG_TOOLS_DIR}
	sudo git fetch origin 1634c6a556d1f2c24897bf74156c6449486e8941
        sudo git checkout 1634c6a556d1f2c24897bf74156c6449486e8941
fi

pr_info "############################"
pr_info "# android-rust setup #"
pr_info "############################"
if [[ ! -d ${ANDROID_RUST_DIR} ]] ; then
        sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 ${ANDROID_RUST_LINK} ${ANDROID_RUST_DIR}
        cd ${ANDROID_RUST_DIR}
	sudo git fetch origin 442511af884f074018466f85b4daadd4b0ac0050
        sudo git checkout 442511af884f074018466f85b4daadd4b0ac0050
fi

pr_info "#####################"
pr_info "# Done             #"
pr_info "#####################"

exit 0
