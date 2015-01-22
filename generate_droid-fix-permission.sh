#!/bin/sh

# Generate droid-permission-fixup.sh
# ref: https://github.com/mer-hybris/droid-system-packager/blob/master/bin/droid-system-prepare.sh
# grep -v /dev/input/ is here because otherwise directories in /dev/input/ get 660 permissions
# and groups do not have proper permissions to access those.

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage:"
    echo "$0 <ramdisk dir> <machine> <target-file>"
    exit
fi

RAMDISK_DIR="$1"
MACHINE="$2"
TARGET_FILE="$3"

mkdir -p $(dirname ${TARGET_FILE})
echo > ${TARGET_FILE}

function generate_sh() {
    RC_FILE="$1"
    TARGET="$2"
    if [ -e ${RC_FILE} ]; then
    grep -E "(^/dev/[^\w]*/[^\w]*)"  ${RC_FILE} | \
        grep -v /dev/input/ | grep -v /dev/block/ | sed "s|/dev/log/|/dev/alog/|g" | \
        awk '{ print "chmod " $2 " " $1 "; chown " $3 ":" $4 " " $1 }'  >> ${TARGET}

    grep -E "(^/sys/)" ${RC_FILE} | \
        awk '{ print "chmod " $3 " " $1 "/" $2 "; chown " $4 ":" $5 " " $1 "/" $2 }' >> ${TARGET}
    fi
}

generate_sh ${RAMDISK_DIR}/ueventd.rc ${TARGET_FILE}
generate_sh ${RAMDISK_DIR}/ueventd.${MACHINE}.rc ${TARGET_FILE}

chmod +x ${TARGET_FILE}
