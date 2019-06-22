#!/bin/bash
rm .version
# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
KERNEL="Image"
DTBIMAGE="dtb"

DEFCONFIG="mido_defconfig"


## Always ARM64
ARCH=arm64

# Paths
KERNEL_DIR=`pwd`
REPACK_DIR=$KERNEL_DIR/AnyKernel2/
PATCH_DIR=$KERNEL_DIR/AnyKernel2/patch
MODULES_DIR=$KERNEL_DIR/AnyKernel2/modules
ZIP_MOVE=$KERNEL_DIR/AK-releases/
ZIMAGE_DIR=$KERNEL_DIR/out/arch/arm64/boot

# Vars
BASE_AK_VER="SOVIET-STAR"
DATE=`date +"%Y%m%d-%H%M"`
AK_VER="$BASE_AK_VER$VER"
ZIP_NAME="$AK_VER"-"$DATE"
export LOCALVERSION=~`echo $AK_VER`
export LOCALVERSION=~`echo $AK_VER`
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=NATO66613
export KBUILD_BUILD_HOST=PENTAGON

## Always use all threads
THREADS=$(nproc --all)
export CLANG_PATH=${HOME}/syberia/prebuilts/clang/host/linux-x86/clang-r353983b/bin
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=${HOME}/syberia/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu-8.x/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=${HOME}/syberia/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-

# Kernel Details
VER=".R3.01"

# Functions
function clean_all {
		cd $REPACK_DIR
		rm *.zip
		rm Image.gz-dtb
		cd $KERNEL_DIR
		make O=out clean && make O=out mrproper
}

function make_kernel {
		echo
		make O=out $DEFCONFIG
		make O=out ARCH=${ARCH} CC=clang -j${THREADS}

}

function make_zip {
		cp $ZIMAGE_DIR/Image.gz-dtb $REPACK_DIR/
		cd $REPACK_DIR
		zip -r9 `echo $ZIP_NAME`.zip *
		cd $KERNEL_DIR
}


DATE_START=$(date +"%s")


echo -e "${green}"
echo "-----------------"
echo "Making SOVIET Kernel:"
echo "-----------------"
echo -e "${restore}"


echo

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build?" dchoice
do
case "$dchoice" in
	y|Y )
		make_kernel
		make_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo

