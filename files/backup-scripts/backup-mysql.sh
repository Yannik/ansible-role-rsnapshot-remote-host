#!/usr/bin/env bash

set -o errexit
set -o nounset

mysqldump_params=""
mysql_params=""
defaults_extra_file=""

while getopts ":u:d:" opt; do
  case $opt in
    u)
      mysqldump_params="${mysqldump_params}--user ${OPTARG} "
      mysql_params="${mysql_params}--user ${OPTARG} "
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

. /etc/rsnapshot/backup-scripts/common.sh

create_backup_dir

databases=$(mysql ${defaults_extra_file} ${mysql_params} -e "SHOW DATABASES" --batch --skip-column-names |
            grep -Ev "(information_schema|performance_schema)")

for db in $databases; do
  # Source: https://dba.stackexchange.com/questions/33883/what-is-the-proper-way-to-backup-mysql-database-with-rsnapshot
  mysqldump ${defaults_extra_file} --lock-tables --routines --events --triggers --force ${mysqldump_params} --databases $db > mysqldump-${db}.sql
  rm -rf mysqldump-${db}.sql.gz
  gzip --rsyncable mysqldump-${db}.sql
done

