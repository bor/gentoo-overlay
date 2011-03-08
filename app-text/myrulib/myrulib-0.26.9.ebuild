# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
WX_GTK_VER="2.8"

inherit eutils wxwidgets

DESCRIPTION="Free (free and open) a program for organizing your home library (collection) e-book"
HOMEPAGE="http://www.lintest.ru/wiki/MyRuLib"
SRC_URI="http://www.lintest.ru/pub/${P}.tar.bz2"
#SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"
#SRC_URI="http://github.com/lintest/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3
	>=dev-libs/expat-2
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}"

src_configure() {
	econf --without-strip
}

src_install() {
	einstall || die
}
