[![Build Status](https://travis-ci.org/bor/gentoo-overlay.svg)](https://travis-ci.org/bor/gentoo-overlay)

Here you can find some ebuilds for Gentoo Linux.
Be carefull for use it! You must undestand what you do.

### USAGE

Under root:
```
# if you don't have it yet
emerge layman
layman -f -o https://github.com/bor/gentoo-overlay/raw/master/overlay.xml -a bor
```
After this you can emerge everything from this overlay.
