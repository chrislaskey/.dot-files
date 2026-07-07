#!/usr/bin/env bash

mkdir -p /mnt/synology/Storage/Dropbox

rsync -ah --delete --info=progress2 --no-inc-recursive ~/Dropbox/ /mnt/synology/Storage/Dropbox
