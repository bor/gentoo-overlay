# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Fight Flash Fraud, or Fight Fake Flash"
HOMEPAGE="http://oss.digirati.com.br/f3/"
SRC_URI="https://github.com/AltraMayor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+experimental"

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	emake
	if use "experimental"; then
	   	emake experimental
	fi
}

src_install() {
	dodoc README
	dobin f3write
	dobin f3read
	if use "experimental"; then
		dobin f3brew
		dobin f3probe
		dobin f3fix
	fi
}
