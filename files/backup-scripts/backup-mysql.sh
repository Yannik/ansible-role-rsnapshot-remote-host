#!/usr/bin/env bash

set -o errexit

mkdir -p /var/rsnapshot-backup/
cd /var/rsnapshot-backup/

mysqldump --all-databases --lock-tables --routines --events --triggers --force > mysqldump.sql
rm -f mysqldump.sql.gz
gzip mysqldump.sql
