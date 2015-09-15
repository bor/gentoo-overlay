# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Bash script for split audio CD image files with cue sheet to tracks and write tags"
HOMEPAGE="http://code.google.com/p/cue2tracks/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="aac flac flake mac mp3 shorten tta vorbis wavpack"

DEPEND=""

RDEPEND="
	app-shells/bash
	app-cdr/cuetools
	>=media-sound/shntool-3.0.0
	aac? ( media-libs/faac media-libs/faad2 )
	flac? ( media-libs/flac )
	flake? ( media-sound/flake )
	mac? ( media-sound/mac media-sound/apetag )
	mp3? ( media-sound/lame media-sound/id3v2 )
	shorten? ( media-sound/shorten )
	tta? ( media-sound/ttaenc )
	vorbis? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack media-sound/apetag )
"

src_install() {
	dobin "${PN}" || die
	dodoc AUTHORS INSTALL ChangeLog README TODO
}

pkg_postinst() {
	echo ""
	einfo 'To get help about usage run "$ cue2tracks -h"'
	echo ""
}
