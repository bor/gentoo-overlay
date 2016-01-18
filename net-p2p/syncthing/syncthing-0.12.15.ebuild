# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="http://syncthing.net/"
SRC_URI="https://github.com/syncthing/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

inherit eutils golang-build systemd user

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

DEPEND="
	dev-lang/go
	dev-go/godep
"
RDEPEND="${DEPEND}"

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

	local logrotate_f=${PN}.logrotate
	cp "${FILESDIR}/${logrotate_f}".in "${TMPDIR}/${logrotate_f}" || die
	if use systemd ; then
		sed -i 's/@RESTART_CMD@/systemctl kill -s HUP syncthing/' \
			"${TMPDIR}/${logrotate_f}" || die
	else
		sed -i 's:@RESTART_CMD@:/etc/init.d/syncthing restart:' \
			"${TMPDIR}/${logrotate_f}" || die
fi
}

src_compile() {
	local ldflags="-w -X main.Version v${PV} -X main.BuildStamp $(date +%s) -X main.BuildUser $(whoami) -X main.BuildHost $(hostname -s)"
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		godep go build -ldflags "${ldflags}" -tags noupgrade "./cmd/${PN}" || die
}

src_install() {
	dobin syncthing || die
	einstalldocs
	doman man/*.[157] || die

	if use systemd; then
		systemd_dounit etc/linux-systemd/system/${PN}@.service
		systemd_douserunit etc/linux-systemd/user/${PN}.service
	else
		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
	fi

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}

	insinto /etc/logrotate.d
	newins "${TMPDIR}/${PN}.logrotate" ${PN}
}

pkg_postinst() {
	if use systemd; then
		MSG_START="systemctl start ${PN}@${PN}"
		MSG_ENABLE="systemctl enable ${PN}@${PN}"
		MSG_SETUP="systemctl start ${PN}@<user>\n (to run it under your user)"
	else
		MSG_START="/etc/init.d/${PN} start"
		MSG_ENABLE="rc-update add ${PN} default"
		MSG_SETUP="edit /etc/conf.d/${PN}"
	fi

	einfo
	elog "To run ${PN} as a service:"
	elog "  ${MSG_START}"
	elog "To enable it at startup:"
	elog "  ${MSG_ENABLE}"
	elog "There is an ability to custom setup, for example:"
	elog "  ${MSG_SETUP}"
	einfo
	ewarn
	ewarn "v0.12.x is not compatible with the v0.11.x releases!"
	ewarn "Use this release if you are a new user, or when you are ready to upgrade all devices in your cluster."
	ewarn
}
