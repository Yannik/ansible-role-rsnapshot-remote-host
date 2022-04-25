#!/usr/bin/env bash

set -o errexit
set -o nounset

skip="tar"

while getopts ":s:" opt; do
  case $opt in
    s)
      skip=${OPTARG}
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

. /etc/rsnapshot/backup-scripts/common.sh

create_backup_dir

# Remove old backup
rm -rf /var/backup/gitlab/*

/opt/gitlab/bin/gitlab-backup create SKIP="$skip" GZIP_RSYNCABLE=yes CRON=1
