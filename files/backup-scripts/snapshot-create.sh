#!/usr/bin/env bash

set -o errexit
set -o nounset

volume=""
size="100%FREE"

while getopts ":v:s:" opt; do
  case $opt in
    v)
      volume=${OPTARG}
      ;;
    s)
      size=${OPTARG}
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

create_backup_dir

if lvs --no-headings --select 'lv_name=backup_snapshot' -o lv_name |grep -q backup_snapshot; then
  >&2 echo "ERROR: backup_snapshot lv already exists"
  exit 1
fi

lvcreate --snapshot --name backup_snapshot --permission r -l "$size" "$volume"

volumegroup=$(echo "$volume" | cut -d "/" -f1 | sed 's/-/--/g')

mkdir -p "$BACKUP_DIR/snapshot"
mount -o ro /dev/mapper/$volumegroup-backup_snapshot "$BACKUP_DIR/snapshot"


