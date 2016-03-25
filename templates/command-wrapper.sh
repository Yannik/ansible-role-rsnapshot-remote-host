#!/bin/bash

case "$SSH_ORIGINAL_COMMAND" in
    sudo\ /etc/rsnapshot/backup-scripts/*)
        $SSH_ORIGINAL_COMMAND
        ;;
    *)
        sudo /usr/local/bin/rrsync -ro /
        ;;
esac