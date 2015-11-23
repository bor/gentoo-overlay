# Copyright 1999-2015 Gentoo Foundation
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
IUSE="+logrotate systemd"

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
		systemd_newunit etc/linux-systemd/system/${PN}@.service ${PN}@.service
	else
		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
	fi

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${TMPDIR}/${PN}.logrotate" ${PN}
	fi
}

pkg_postinst() {
	if use systemd; then
		MSG_START="systemctl start ${PN}@<user>"
		MSG_ENABLE="systemctl enable ${PN}@<user>"
	else
		MSG_START="/etc/init.d/${PN} start"
		MSG_ENABLE="rc-update add ${PN} default"
	fi

	einfo
	elog "To run ${PN} as a service:"
	elog "  ${MSG_START}"
	elog "To enable it at startup:"
	elog "  ${MSG_ENABLE}"
	einfo
	ewarn
	ewarn "v0.12.x is not compatible with the v0.11.x releases!"
	ewarn "Use this release if you are a new user, or when you are ready to upgrade all devices in your cluster."
	ewarn
}
