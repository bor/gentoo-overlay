# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# note: dev-perl/Gtk2-MozEmbed left out in purpose because gtkmozembed and xulrunner are obsolete

EAPI=4
inherit fdo-mime vcs-snapshot

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="http://gmusicbrowser.org/"
SRC_URI="https://github.com/squentin/${PN}/tarball/3293bcbf09dce933b991a98cd5bfc333477e42a8
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus gstreamer libnotify minimal mplayer webkit"

RDEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	virtual/perl-MIME-Base64
	dbus? ( dev-perl/Net-DBus )
	gstreamer? (
		dev-perl/GStreamer
		dev-perl/GStreamer-Interfaces
		media-plugins/gst-plugins-meta
	)
	!gstreamer? ( !mplayer? (
		media-sound/alsa-utils
		media-sound/flac123
		|| ( media-sound/mpg123 media-sound/mpg321 )
		media-sound/vorbis-tools
	) )
	libnotify? ( dev-perl/Gtk2-Notify )
	!minimal? (
		dev-perl/AnyEvent-HTTP
		dev-perl/gnome2-wnck
	)
	mplayer? ( || ( media-video/mplayer media-video/mplayer2 ) )
	webkit? ( dev-perl/Gtk2-WebKit )"
DEPEND="sys-devel/gettext"

LANGS="cs de es fr hu it ko nl pl pt pt_BR ru sv zh_CN"
for l in ${LANGS}; do
	IUSE="$IUSE linguas_${l}"
done
unset l

src_prepare() {
	sed -i -e '/menudir/d' Makefile || die
}

src_install() {
	local LINGUAS
	local l
	for l in ${LANGS}; do
		if use linguas_${l}; then
			LINGUAS="${LINGUAS} ${l}"
		fi
	done

	emake \
		DOCS="AUTHORS NEWS README" \
		DESTDIR="${D}" \
		iconsdir="${D}/usr/share/pixmaps" \
		LINGUAS="${LINGUAS}" \
		VERSION="${PV}" \
		install

	dohtml layout_doc.html
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
