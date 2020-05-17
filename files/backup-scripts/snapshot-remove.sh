#!/usr/bin/env bash

set -o errexit
set -o nounset

volume=""

while getopts ":v:" opt; do
  case $opt in
    v)
      volume=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z "$volume" ]; then
  echo "You need to specify a volume with -v"
  exit 1
fi

. /etc/rsnapshot/backup-scripts/common.sh

volumegroup=$(echo "$volume" | cut -d "/" -f1)

umount "$BACKUP_DIR/snapshot"
lvremove -y "$volumegroup/backup_snapshot"
rmdir "$BACKUP_DIR/snapshot"
