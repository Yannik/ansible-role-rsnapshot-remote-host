BACKUP_DIR=/var/rsnapshot-backup

function create_backup_dir() {
  mkdir -p /var/rsnapshot-backup/
  cd /var/rsnapshot-backup/
  chmod 700 .
  umask 077
}
