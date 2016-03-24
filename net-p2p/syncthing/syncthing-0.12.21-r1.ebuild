# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://github.com/syncthing/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

inherit golang-build systemd user

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/go
	dev-go/godep
"
RDEPEND="${DEPEND}"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

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

src_test() {
	cd src/${EGO_PN}
	go run build.go test || die "test failed"
}

src_install() {
	dobin syncthing
	einstalldocs
	doman man/*.[157]

	systemd_dounit etc/linux-systemd/system/${PN}@.service \
		etc/linux-systemd/system/${PN}-resume.service
	systemd_douserunit etc/linux-systemd/user/${PN}.service
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}
}

pkg_postinst() {
	einfo
	elog "You can use run ${PN} as a service"
	elog "For openrc:"
	elog "  start at boot:    rc-update add ${PN} default"
	elog "  run as service:   /etc/init.d/${PN} start"
	elog "  custom setup:     \$EDITOR /etc/conf.d/${PN}"
	elog "Similarly for systemd:"
	elog "      systemctl enable ${PN}@${PN}"
	elog "      systemctl start ${PN}@${PN}"
	elog "      systemctl start ${PN}@<user>"
	einfo
}
