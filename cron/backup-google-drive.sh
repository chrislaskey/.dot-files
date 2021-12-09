#!/usr/bin/env bash

# See: https://serverfault.com/questions/219013/showing-total-progress-in-rsync-is-it-possible/441724

usage() {
cat << EOF
usage: $0 [-v]

This script backs up google drive to local storage

OPTIONS:
   -v Verbose output. Includes percentage completion
      NOTE: this takes significant time to calculate at the beginning
EOF
}

VERBOSE=

while getopts “:h:v” OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    v)
      VERBOSE=true
      ;;
    ?)
      usage
      exit
      ;;
  esac
done

# Implementation

mkdir -p /mnt/synology/Storage/Google\ Drive

if [[ -z $VERBOSE ]]; then
  rsync -a --delete /media/chrislaskey/6E0C95A50C95693B/Users/conta/My\ Drive/ /mnt/synology/Storage/Google\ Drive
else
  rsync -ah --delete --info=progress2 --no-inc-recursive /media/chrislaskey/6E0C95A50C95693B/Users/conta/My\ Drive/ /mnt/synology/Storage/Google\ Drive
fi
