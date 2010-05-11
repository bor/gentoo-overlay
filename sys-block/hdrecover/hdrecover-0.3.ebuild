# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="hdrecover attempts to recover a hard disk that has bad blocks on it"
HOMEPAGE="http://hdrecover.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README NEWS
}
