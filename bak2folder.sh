#!/bin/bash
# Description:
#  Backup boot and / partitions to a specific folder.
#  By default /backup if no input by command line.
# Version:
#  20181024 - First release

bakdir="/backup"

if [ ${#} -eq 0 ]; then
  read -p "No input, use ${bakdev} as default backup device, or input now:" iDev
  if [ "${iDev}" != "" ]; then
    bakdev=${iDev}
  fi
else
  bakdev=${1}
fi

if [ -d ${bakdir} ]; then
  echo -n "All files in ${bakdir} will be deleted! continue/Stop:"
  read -p 1 arg
  case ${arg} in
    c|C)
      ;;
    *)
      echo -e "\nStopped"
      exit 1
      ;;
  esac
  sudo rm -r ${bakdir}
fi

echo -e "\nWill backup to \033[32m${bakdir}\033[0m..."
sudo mkdir -p ${bakdir}
cd ${bakdir}
sudo touch bak$(date +%Y%m%d%H%M%S)
sudo cp -r /boot ./boot
echo -e "\033[32mboot\033[0m partition backuped"
sudo mkdir rootfs
cd rootfs
sudo mkdir boot
sudo mkdir dev
sudo mkdir media
sudo mkdir mnt
sudo mkdir proc
sudo mkdir run
sudo mkdir sys
sudo mkdir tmp
sudo chmod a+w tmp

sudo rsync --force -rltWDEgopt --stats --progress --exclude '/var/swap' --exclude '.gvfs' --exclude '/dev' --exclude '/media' --exclude '/mnt' --exclude '/proc' --exclude '/run' --exclude '/sys' --exclude '/tmp' --exclude 'lost\+found' --exclude '/boot' --exclude ${bakdir} / ${bakdir}/rootfs
cd ..
sudo touch bakend$(date +%Y%m%d%H%M%S)
echo -e "\033[32m/\033[0m partition backuped\nAll done"
exit 0
