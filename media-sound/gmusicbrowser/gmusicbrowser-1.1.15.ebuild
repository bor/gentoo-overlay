# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fdo-mime gnome2-utils

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="http://gmusicbrowser.org/"
SRC_URI="http://${PN}.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus extras gstreamer gstreamer-0 libnotify mplayer webkit"

GSTREAMER_DEPEND="
	dev-perl/Glib-Object-Introspection"
GSTREAMER0_DEPEND="
	dev-perl/GStreamer
	dev-perl/GStreamer-Interfaces
	media-plugins/gst-plugins-meta:0.10"
MPLAYER_DEPEND="media-video/mplayer"
MPV_DEPEND="media-video/mpv"
OTHER_DEPEND="
	media-sound/alsa-utils
	media-sound/flac123
	|| ( media-sound/mpg123 media-sound/mpg321 )
	media-sound/vorbis-tools"

RDEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	virtual/perl-MIME-Base64
	|| ( net-misc/wget dev-perl/AnyEvent-HTTP )
	dbus? ( dev-perl/Net-DBus )
	gstreamer? ( ${GSTREAMER_DEPEND} )
	gstreamer-0? ( ${GSTREAMER0_DEPEND} )
	mplayer? ( || ( ${MPLAYER_DEPEND} ${MPV_DEPEND} ) )
	!gstreamer? ( !mplayer? ( ${OTHER_DEPEND} ) )
	extras? ( dev-perl/gnome2-wnck )
	libnotify? ( dev-perl/Gtk2-Notify )"
DEPEND="sys-devel/gettext"

src_install() {
	emake \
		DOCS="AUTHORS NEWS README" \
		DESTDIR="${D}" \
		iconsdir="${D}/usr/share/icons/hicolor" \
		install

	dohtml layout_doc.html
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	elog "Gmusicbrowser supports gstreamer, mplayer, mpv and mpg123/ogg123..."
	elog "for audio playback. Needed dependencies:"
	elog "Gstreamer: ${GSTREAMER_DEPEND}"
	elog "Gstreamer-0.10: ${GSTREAMER0_DEPEND}"
	elog "mplayer: ${MPLAYER_DEPEND}"
	elog "mpv: ${MPV_DEPEND}"
	elog "mpg123/ogg123...: ${OTHER_DEPEND}"
	elog
	elog "other optional dependencies:"
	elog "	dev-perl/Net-DBus (for dbus support and mpris1/2 plugins)"
	elog "	dev-perl/Gtk2-WebKit (for Web context plugin)"
	elog "	dev-perl/Gtk2-Notify (for Notify plugin)"
	elog "	dev-perl/gnome2-wnck (for Titlebar plugin)"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
