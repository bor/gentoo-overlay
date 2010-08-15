# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Create your own collection of e-books"
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
