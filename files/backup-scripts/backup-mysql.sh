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
            grep -Ev "^(information_schema|performance_schema|sys|mysql)$")

for db in $databases; do
  non_innodb_tables=$(mysql -e "SELECT TABLE_NAME,ENGINE FROM information_schema.tables WHERE table_schema = DATABASE() AND ENGINE != 'InnoDB';" --batch --skip-column-names "$db")
  if [ "$non_innodb_tables" == "" ]; then
    mysqldump_params="${mysqldump_params}--single-transaction "
  else
    echo "Failure to backup database $db using --single-transaction due to MyISAM tables: "
    echo "$non_innodb_tables"
    mysqldump_params="${mysqldump_params}--lock-tables "
  fi

  ignore_tables=$(mysql -e "SELECT TABLE_NAME FROM information_schema.tables WHERE table_schema = DATABASE();" --batch --skip-column-names "$db" | { grep -E "(^cache_|^cf_cache_)" || test $? = 1; })
  for table in $ignore_tables; do
    mysqldump_params="${mysqldump_params}--ignore-table=$db.$table "
  done

  # Source: https://dba.stackexchange.com/questions/33883/what-is-the-proper-way-to-backup-mysql-database-with-rsnapshot
  mysqldump ${defaults_extra_file} --routines --events --triggers --force ${mysqldump_params} --databases $db > mysqldump-${db}.sql
  rm -rf mysqldump-${db}.sql.gz
  gzip --rsyncable mysqldump-${db}.sql
done

