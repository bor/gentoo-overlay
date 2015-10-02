# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="http://syncthing.net/"
SRC_URI="https://github.com/syncthing/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

inherit eutils golang-build user

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+logrotate"

DEPEND="
	dev-lang/go
	dev-go/godep
"
RDEPEND="${DEPEND}
	logrotate? ( app-admin/logrotate )
"

DOCS=( AUTHORS README.md )

EGO_PN="github.com/${PN}/${PN}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	# prepare dir structure
	mkdir -p "src/${EGO_PN}" && rmdir "src/${EGO_PN}" || die
	# link the source dir with "src/"
	ln -sf "${S}" "src/${EGO_PN}" || die
}

src_compile() {
	local ldflags="-w -X main.Version v${PV} -X main.BuildStamp $(date +%s) -X main.BuildUser $(whoami) -X main.BuildHost $(hostname -s)"
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		godep go build -ldflags "${ldflags}" -tags noupgrade "./cmd/${PN}" || die
}

src_install() {
	dobin syncthing || die
	einstalldocs
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/syncthing.logrotate" syncthing
	fi
}

pkg_postinst() {
	einfo
	elog "To run ${PN} as a service:"
	elog "  /etc/init.d/${PN} start"
	elog "To enable it at startup:"
	elog "  rc-update add ${PN} default"
	einfo
}
