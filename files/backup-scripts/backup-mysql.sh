#!/usr/bin/env bash

set -o errexit

mysqldump_params=""

while getopts ":u:p:" opt; do
  case $opt in
    u)
      mysqldump_params="${mysqldump_params}--user ${OPTARG} "
      ;;
    p)
      mysqldump_params="${mysqldump_params}--password=${OPTARG} "
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

mkdir -p /var/rsnapshot-backup/
cd /var/rsnapshot-backup/

mysqldump --all-databases --lock-tables --routines --events --triggers --force ${mysqldump_params} > mysqldump.sql
rm -f mysqldump.sql.gz
gzip mysqldump.sql
