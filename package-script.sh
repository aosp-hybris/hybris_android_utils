#!/bin/sh

PACKAGE_TAR=${TARGET_PRODUCT}.tar
PACKAGE=${PACKAGE_TAR}.gz

if [ -z "$TARGET_PRODUCT" ]; then
    echo "please setup TARGET_PRODUCT env"
    exit
fi

# remove old one
rm -rf $PACKAGE > /dev/null 2>&1

# package android part
TARGET_OBJ=${OUT/$ANDROID_BUILD_TOP\//}/obj

find $OUT -print  | \
    sed "s,$ANDROID_BUILD_TOP/,," | \
    tar acvf ${PACKAGE_TAR} -T - --exclude=$TARGET_OBJ --exclude=system.img --exclude=ramdisk.img --exclude=userdata.img

HOST_OBJ=${ANDROID_HOST_OUT/$ANDROID_BUILD_TOP\//}/obj
# package linux host tools
find $ANDROID_HOST_OUT -not \( -path $ANDROID_HOST_OUT/obj -prune \) -print  | \
    sed "s,$ANDROID_BUILD_TOP/,," | \
    tar acvf ${PACKAGE_TAR}.1  -T  - --exclude=$HOST_OBJ

# concat two tar file
tar --concatenate --file=${PACKAGE_TAR} ${PACKAGE_TAR}.1

# remove extra tar file
rm -rf ${PACKAGE_TAR}.1 > /dev/null 2>&1

# compress package
gzip $PACKAGE_TAR
#find $OUT  -not \( -path $ANDROID_PRODUCT_OUT/obj  \) -print |less
