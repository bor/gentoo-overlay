# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR="FLORA"
MODULE_VERSION="0.05"

inherit perl-module

DESCRIPTION="Perl interface to libnotify"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="
	dev-perl/glib-perl
	dev-perl/gtk2-perl
	>=x11-libs/libnotify-0.7
"
DEPEND="${RDEPEND}
	dev-perl/extutils-depends
	dev-perl/extutils-pkgconfig
"
TDEPEND="dev-perl/Test-Exception"

PATCHES=( "${FILESDIR}"/${P}-libnotify-0.7.patch )
