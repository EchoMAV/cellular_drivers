#!/bin/bash

SUDO=$(test ${EUID} -ne 0 && which sudo)
SYSCFG=/etc/systemd
UDEV_RULESD=/etc/udev/rules.d

APN="teal"

opstr+="a:-:"
while getopts "${opstr}" OPTION; do
  case $OPTION in
  -) case ${OPTARG} in
    apn)
      APN="${!OPTIND}"
      OPTIND=$(($OPTIND + 1))
      ;;
    esac ;;
  esac
done

if [ ! -z "$APN" ]; then
  if ischroot ; then
    echo "Removing existing network manager profile for Cellular..."
    $SUDO rm -f /etc/NetworkManager/system-connections/Cellular*.nmconnection
    echo "Adding network manager profile for Cellular..."
    echo "[connection]
id=Cellular
uuid=$(uuidgen)
type=gsm
interface-name=cdc-wdm0

[gsm]
apn=$APN

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto

[proxy]
" | $SUDO tee /etc/NetworkManager/system-connections/Cellular.nmconnection
    $SUDO chmod 600 /etc/NetworkManager/system-connections/Cellular.nmconnection
  else
    echo "Removing existing network manager profile for Cellular..."
    $SUDO nmcli con delete 'Cellular'
    echo "Adding network manager profile for Cellular..."
    $SUDO nmcli connection add type gsm ifname cdc-wdm0 con-name "Cellular" apn "$APN" connection.autoconnect yes
    echo "Waiting for conneciton to come up..."
    sleep 5
    $SUDO nmcli con show
    true
  fi
else
  echo "APN cannot be blank, doing nothing!"
  false
fi
