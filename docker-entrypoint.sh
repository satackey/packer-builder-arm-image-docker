#!/bin/sh
set -ex

# Start binfmt (for kpartx)
/etc/init.d/binfmt-support start > /dev/null

# Execute the command if there is an argument
if [ $# -gt 0 ];then
    $@
    exit
fi

PACKERFILE=$(realpath $PACKERFILE)
IMAGE_DEST=$(dirname $PACKERFILE)/$(basename $PACKERFILE | sed 's/\.[^\.]*$//').img

# Avoid slow Docker shared filesystem by generating images in other paths
rm -f output-arm-image
mkdir -p /root/output-arm-image
ln -s /root/output-arm-image/

packer build $PACKERFILE

mv output-arm-image/image $IMAGE_DEST
rm -f output-arm-image