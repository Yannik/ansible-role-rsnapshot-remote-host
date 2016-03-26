#!/bin/bash

# Source: http://binblog.info/2008/10/20/openssh-going-flexible-with-forced-commands/
case "$SSH_ORIGINAL_COMMAND" in
    sudo\ /etc/rsnapshot/backup-scripts/*)
        $SSH_ORIGINAL_COMMAND
        ;;
    test)
        ;;
    *)
        sudo /usr/local/bin/rrsync -ro /
        ;;
esac
