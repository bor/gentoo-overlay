# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker

MY_PN="${PN%-bin}"

DESCRIPTION="Crossplatform configuration tool for the Betaflight flight control system"
HOMEPAGE="https://github.com/betaflight/betaflight-configurator"
SRC_URI="https://github.com/betaflight/${MY_PN}/releases/download/${PV}/betaflight-configurator_${PV}_linux64-portable.zip"
LICENSE="GPL-3"
RESTRICT="bindist mirror test"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="acct-group/dialout"

QA_PREBUILT="*"
S="${WORKDIR}/Betaflight Configurator"

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local BFC_HOME="/opt/betaflight/${MY_PN}"
	dodir ${BFC_HOME} /usr/share/{applications,desktop-directories}
	domenu betaflight-configurator.desktop
	insinto "${BFC_HOME}"
	doins -r * || die "failed to install files"
	fperms +x "$BFC_HOME"/${MY_PN} \
		"$BFC_HOME"/chrome_crashpad_handler \
		"$BFC_HOME"/lib/*.so
	dosym "$BFC_HOME"/${MY_PN} /usr/bin/${MY_PN}
}
