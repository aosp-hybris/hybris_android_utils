#!/bin/sh

if [ -z "$TARGET_PRODUCT" ]; then
	echo "please setup TARGET_PRODUCT env"
	exit
fi

find out/target/product/$TARGET_PRODUCT -print | \
tar acvf a.tar.gz  -T - --exclude=out/target/product/*/obj --exclude=system.img --exclude=ramdisk.img --exclude=userdata.img
