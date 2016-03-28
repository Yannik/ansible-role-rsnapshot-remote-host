#!/bin/bash
# Security check: https://security.stackexchange.com/questions/118688/
set -o errexit
set -o noglob
shopt -s extglob

# Use exec to run the commands. (see https://unix.stackexchange.com/questions/270929/use-case-practical-example-for-bash-builtin-exec)
# `exec echo a && echo b`
# or
# `exec echo a; echo b`
# will only run the first echo.
# `exec` replaces the current shell with the specified program, so
# the shell will automatically exit after the command is executed.
case "$SSH_ORIGINAL_COMMAND" in
    sudo\ /etc/rsnapshot/backup-scripts/[^./]*([^/]))
        exec $SSH_ORIGINAL_COMMAND
        ;;
    test)
        ;;
    *)
        exec sudo /usr/local/bin/rrsync -ro /
        ;;
esac
