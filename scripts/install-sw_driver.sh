#!/bin/bash

# exit on any error
set -e

# get script directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# install sierra wireless USB driver. This is not strictly neccesary but may be required if all the interfaces are needed (DM, NMEA, AT), should show up as /dev/ttuUSB0, 1, 2
echo "Building Sierra Wireless Driver..."
cd "$SCRIPT_DIR"/../sw_driver/
package_name=$(sed -n 's/^PACKAGE_NAME="\([^"]*\)"/\1/p' dkms.conf)
package_version=$(sed -n 's/^PACKAGE_VERSION="\([^"]*\)"/\1/p' dkms.conf)
# add package version if not already added
if ! dkms status $package_name/$package_version | grep -q installed$ ; then
    dkms add .
fi
if ischroot ; then
    kernel_version=$(ls -AU /lib/modules | head -1)
    dkms build echomav-sw-driver/$package_version -k $kernel_version
    echo "Installing Sierra Wireless Driver..."
    dkms install echomav-sw-driver/$package_version -k $kernel_version
else
    dkms build echomav-sw-driver/$package_version
    echo "Installing Sierra Wireless Driver..."
    dkms install echomav-sw-driver/$package_version
fi
