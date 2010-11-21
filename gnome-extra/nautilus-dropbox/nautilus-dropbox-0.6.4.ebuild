# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils gnome2 python linux-info

DESCRIPTION="Store, Sync and Share Files Online"
HOMEPAGE="http://www.getdropbox.com/"
SRC_URI="http://www.getdropbox.com/download?dl=packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=gnome-base/nautilus-2.16
	>=dev-libs/glib-2.14
	dev-python/pygtk
	>=x11-libs/gtk+-2.12
	>=x11-libs/libnotify-0.4.4
	net-misc/wget
	x11-libs/libXinerama"

DEPEND="${RDEPEND}
	dev-python/docutils
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

G2CONF="${G2CONF} $(use_enable debug)"

CONFIG_CHECK="INOTIFY_USER"

pkg_setup () {
	python_set_active_version 2
	linux-info_pkg_setup

	# create the group for the daemon, if necessary
	# truthfully this should be run for any dropbox plugin
	enewgroup dropbox
}

src_prepare () {
	gnome2_src_prepare
	python_convert_shebangs 2 dropbox.in || die
}

src_configure () {
	econf --disable-static
}
src_install() {
	gnome2_src_install

	# Allow only for users in the dropbox group
	# see http://forums.getdropbox.com/topic.php?id=3329&replies=5#post-22898
	local extensiondir="$(pkg-config --variable=extensiondir libnautilus-extension)"
	fowners root:dropbox "${extensiondir}"/libnautilus-dropbox.{la,so} || die
	fperms o-rwx "${extensiondir}"/libnautilus-dropbox.{la,so} || die

	find "${D}" -name '*.la' -exec rm -f {} + || die
}

pkg_postinst () {
	gnome2_pkg_postinst

	elog "Add any users who wish to have access to the dropbox nautilus"
	elog "plugin to the group 'dropbox'."
	elog
	elog "If you've installed old version, Remove \${HOME}/.dropbox-dist first."
	elog
	elog " $ rm -rf \${HOME}/.dropbox-dist"
	elog " $ dropbox start -i"
}
