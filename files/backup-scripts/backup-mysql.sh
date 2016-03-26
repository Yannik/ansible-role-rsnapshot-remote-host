#!/usr/bin/env bash

set -o errexit

mysqldump_params=""
defaults_extra_file=""

while getopts ":u:d:" opt; do
  case $opt in
    u)
      mysqldump_params="${mysqldump_params}--user ${OPTARG} "
      ;;
    d)
      defaults_extra_file="--defaults-extra-file=${OPTARG}"
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
chmod -R 700 .
umask 077

mysqldump ${defaults_extra_file} --all-databases --lock-tables --routines --events --triggers --force ${mysqldump_params} > mysqldump.sql
rm -f mysqldump.sql.gz
gzip mysqldump.sql
