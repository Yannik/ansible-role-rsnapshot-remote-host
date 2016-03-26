Description
=========
[![Build Status](https://travis-ci.org/Yannik/ansible-role-rsnapshot-remote-host.svg?branch=master)](https://travis-ci.org/Yannik/ansible-role-rsnapshot-remote-host)

To be used in conjunction with `Yannik/rsnapshot-backup-host`.

Role Variables
--------------

  * `rsnapshot_backup_host`: Which hosts will pull backups from this host (must be ansible hostnames)

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - role: Yannik/rsnapshot-remote-host
           rsnapshot_backup_host: examplehost

License
-------

GPLv2

Author Information
------------------

Yannik Sembritzki
