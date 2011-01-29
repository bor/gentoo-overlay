# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit wxwidgets eutils

DESCRIPTION="Free (free and open) a program for organizing your home library (collection) e-book"
HOMEPAGE="http://www.lintest.ru/wiki/MyRuLib"
SRC_URI="http://www.lintest.ru/pub/${P/-/_}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3
	dev-libs/expat
	x11-libs/wxGTK"

DEPEND="$RDEPEND"

src_install() {
	einstall || die
}
