#!/usr/bin/env bash

set -o errexit
set -o nounset

while getopts ":o:" opt; do
  case $opt in
    o)
      only_database=${OPTARG}
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

databases=$(sudo -i -u gitlab-psql -- /opt/gitlab/embedded/bin/psql \
	    -h /var/opt/gitlab/postgresql -d postgres --tuples-only \
	    -c 'SELECT datname FROM pg_database' |
            grep -Ev "(postgres|template0|template1)")

for db in $databases; do
  if [ ! -z "${only_database:-}" ] && [ "$db" != "$only_database" ]; then
    continue
  fi
  sudo -i -u gitlab-psql -- \
       /opt/gitlab/embedded/bin/pg_dump --clean \
       -h /var/opt/gitlab/postgresql $db \
       > pg_dump-$db.psql
  rm -rf pg_dump-${db}.psql.gz
  gzip --rsyncable pg_dump-${db}.psql
done

