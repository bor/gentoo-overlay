# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
HOMEPAGE="https://github.com/kimci86/bkcrack"
SRC_URI="https://github.com/kimci86/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-text/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DBKCRACK_BUILD_DOC=$(usex doc)
		-DBKCRACK_BUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/src/bkcrack"
	einstalldocs
	if use doc; then
		dodoc -r "${BUILD_DIR}/doc/html"
	fi
}
