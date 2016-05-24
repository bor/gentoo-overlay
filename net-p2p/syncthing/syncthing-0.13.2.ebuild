# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGO_PN="github.com/${PN}/${PN}"

inherit golang-vcs-snapshot systemd user versionator

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS=( README.md AUTHORS CONTRIBUTING.md )

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_compile() {
	cd src/${EGO_PN}
	GOPATH="${S}:$(get_golibdir_gopath)" \
		go run build.go -version "v${PV}" -no-upgrade || die "build failed"
}

src_test() {
	cd src/${EGO_PN}
	go run build.go test || die "test failed"
}

src_install() {
	cd src/${EGO_PN}
	dobin bin/*
	doman man/*.[157]
	einstalldocs
	systemd_dounit etc/linux-systemd/system/${PN}@.service \
		etc/linux-systemd/system/${PN}-resume.service
	systemd_douserunit etc/linux-systemd/user/${PN}.service
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}
}

pkg_postinst() {
	if [[ $(get_version_component_range 2) -gt \
			$(get_version_component_range 2 ${REPLACING_VERSIONS}) ]]; then
		ewarn "Version ${PV} is not protocol-compatible with version" \
			"0.$(($(get_version_component_range 2) - 1)).x or lower."
		ewarn "Make sure all your devices are running at least version" \
			"0.$(get_version_component_range 2).0."
	fi
	elog "You can use run ${PN} as a service"
	elog "For openrc:"
	elog "  start at boot:    rc-update add ${PN} default"
	elog "  run as service:   /etc/init.d/${PN} start"
	elog "  custom setup:     \$EDITOR /etc/conf.d/${PN}"
	elog "Similarly for systemd:"
	elog "      systemctl enable ${PN}@${PN}"
	elog "      systemctl start ${PN}@${PN}"
	elog "      systemctl start ${PN}@<user>"
}
