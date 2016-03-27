#!/bin/bash

# Source: http://binblog.info/2008/10/20/openssh-going-flexible-with-forced-commands/

# Use exec to run the commands.
# `exec echo a && echo b`
# or
# `exec echo a; echo b`
# will only run the first echo.
# `exec` replaces the current shell with the specified program, so
# the shell will automatically exit after the command is executed.
case "$SSH_ORIGINAL_COMMAND" in
    sudo\ /etc/rsnapshot/backup-scripts/*)
        exec $SSH_ORIGINAL_COMMAND
        ;;
    test)
        ;;
    *)
        exec sudo /usr/local/bin/rrsync -ro /
        ;;
esac
