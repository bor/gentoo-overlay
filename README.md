[![Build Status](https://travis-ci.org/bor/gentoo-overlay.svg)](https://travis-ci.org/bor/gentoo-overlay)

Here you can find some ebuilds for Gentoo Linux.
Be carefull for use it! You must undestand what you do.

## USAGE

### New way (prefer)

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

### Old way

Under root:
```
## if you don't have it yet
$ emerge layman
$ layman -f -o https://github.com/bor/gentoo-overlay/raw/master/overlay.xml -a bor
```
After this you can emerge everything from this overlay.
