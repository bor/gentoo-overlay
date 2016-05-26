# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils flag-o-matic

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/AltraMayor/${PN}.git"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://github.com/AltraMayor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Fight Flash Fraud, or Fight Fake Flash"
HOMEPAGE="http://oss.digirati.com.br/f3/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+extras"

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( README.md  )

src_compile() {
	append-flags "-fgnu89-inline"
	emake
	if use "extras"; then
		emake extra
	fi
}

src_install() {
	emake PREFIX="${D}/usr" install
	if use "extras"; then
		emake PREFIX="${D}/usr" install-extra
	fi
	einstalldocs
}
