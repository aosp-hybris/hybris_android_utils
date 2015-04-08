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
find $OUT -print | \
    tar acvf ${PACKAGE_TAR}  -T - --exclude=$OUT/obj --exclude=system.img --exclude=ramdisk.img --exclude=userdata.img

# package linux host tools
find $ANDROID_HOST_OUT -print | \
    tar acvf ${PACKAGE_TAR}.1  -T - --exclude=$ANDROID_HOST_OUT/obj

# concat two tar file
tar --concatenate --file=${PACKAGE_TAR} ${PACKAGE_TAR}.1

# remove extra tar file
rm -rf ${PACKAGE_TAR}.1 > /dev/null 2>&1

# compress package
gzip $PACKAGE_TAR