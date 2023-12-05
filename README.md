
Here you can find some ebuilds for Gentoo Linux.

## USAGE

For `>=sys-apps/portage-2.2.16` users is possible to add a custom repository.
For example:
```
$ cat > /etc/portage/repos.conf/bor.conf
[bor]
priority = 51
location = /usr/local/portage
sync-type = git
sync-uri = ssh://git@github.com:bor/gentoo-overlay.git
Ctrl-D
```

See (https://wiki.gentoo.org/wiki/Project:Portage/Sync) for detailed instructions.
