#!/bin/bash

errexit()
{
  echo ""
  echo "$1"
  echo ""
  exit 1
}

usage()
{
  errexit "Usage: $0 [-n | diskid]"
}

if [ $(id -u) -ne 0 ]; then
  errexit "$0 must be run as root user"
fi

PTUUID="$1"
if [ "${PTUUID}" = "" ]; then
  usage
fi
if [ "${PTUUID}" = "-n" ]; then
  echo ${PTUUID} 
  PTUUID=$(uuid | cut -c-8)
fi
PTUUID="$(tr [A-Z] [a-z] <<< "${PTUUID}")"
if [[ ! "${PTUUID}" =~ ^[[:xdigit:]]{8}$ ]]; then
  errexit "Invalid DiskID: ${PTUUID}"
fi
echo ""
echo -n "Set DiskID to ${PTUUID} on /dev/mmcblk0 (y/n)? "
while read -r -n 1 -s answer; do
  if [[ "${answer}" = [yYnN] ]]; then
    echo "${answer}"
    if [[ "${answer}" = [yY] ]]; then
      break
    else
      errexit "Aborted"
    fi
  fi
done
echo ""
fdisk /dev/mmcblk0 <<EOF > /dev/null
p
x
i
0x${PTUUID}
r
p
w
EOF
sync
PARTUUID="$(sed -n 's|^.*PARTUUID=\(\S\+\)\s.*|\1|p' /boot/cmdline.txt)"
if [ "${PARTUUID}" != "" ]; then
  sed -i "s|PARTUUID=\S\+\s|PARTUUID=${PTUUID}-02 |" /boot/cmdline.txt
  sed -i "s|${PARTUUID:0:(${#PARTUUID} - 1)}|${PTUUID}-0|" /etc/fstab
fi
sync