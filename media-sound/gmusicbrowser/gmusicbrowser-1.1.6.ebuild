# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fdo-mime

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="http://gmusicbrowser.org/"
SRC_URI="http://gmusicbrowser.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="dbus gstreamer mplayer mozilla webkit"

RDEPEND=">=dev-lang/perl-5.8
	dev-perl/gtk2-perl
	dev-perl/gtk2-trayicon
	dbus? ( dev-perl/Net-DBus )
	gstreamer? (
		dev-perl/GStreamer
		dev-perl/GStreamer-Interfaces
		media-libs/gst-plugins-good
	)
	mplayer? ( media-video/mplayer )
	!gstreamer? ( !mplayer? (
		media-sound/mpg123
		media-sound/mpg321
		media-sound/vorbis-tools
		media-sound/flac123
		media-sound/alsa-utils
	) )
	mozilla? ( dev-perl/Gtk2-MozEmbed )
	webkit? ( dev-perl/Gtk2-WebKit )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e 's:mpg321:mpg123:g' -i gmusicbrowser* || die "sed failed."
}

src_install() {
	emake DOCS="AUTHORS NEWS README" DESTDIR="${D}" \
		iconsdir="${D}/usr/share/pixmaps" install \
		|| die "emake install failed."
	rm -rf "${D}"/usr/lib/menu/${PN}
	dohtml layout_doc.html
	prepalldocs
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
