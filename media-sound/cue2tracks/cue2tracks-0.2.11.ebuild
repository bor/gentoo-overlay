# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Bash script for split audio CD image files with cue sheet to tracks and write tags."
HOMEPAGE="http://cyberdungeon.org.ru/~killy/projects/${PN}/"
SRC_URI="http://www.ylsoftware.com/files/${P}.tar.bz2"
#http://cyberdungeon.org.ru/~killy/files/projects/${PN}/${P}.tar.bz2

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="aac flac flake id3 mac mp3 mp4 shorten tta vorbis wavpack"

DEPEND=""

RDEPEND="app-shells/bash
	app-cdr/cuetools
	media-sound/shntool
	aac? ( media-libs/faac media-libs/faad2 )
	flac? ( media-libs/flac )
	flake? ( media-sound/flake )
	id3? ( media-sound/id3v2 )
	mac? ( media-sound/mac media-sound/apetag )
	mp3? ( media-sound/lame )
	mp4? ( media-libs/libmp4v2 )
	shorten? ( media-sound/shorten )
	tta? ( media-sound/ttaenc )
	vorbis? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack media-sound/apetag )
"

pkg_setup() {
	if use tta; then
		einfo "ttaenc now not corectly work with shntool!"
		einfo "need some patching"
		epause 2
	fi
#	if use tta && ! built_with_use media-sound/ttaenc shntool ; then
#		echo ""
#		einfo "Installed media-sound/ttaenc not compiled with shntool support"
#		einfo "To recompile it with shntool you need apply the patch"
#		einfo "http://shnutils.freeshell.org/shntool/support/formats/tta/unix/3.4.1/ttaenc-3.4.1-src-shntool.tar.gz"
#		echo ""
#		einfo "add USE flag 'shntool' and add the line at end of section src_unpack():"
#		einfo "    use shntool && epatch \${FILESDIR}/ttaenc-3.x-shntool.patch"
#		echo ""
#		einfo "and reemerge modified media-sound/ttaenc"
#		epause 5
#	fi
}

src_install() {
	dobin "${PN}" || die
	dodoc AUTHORS INSTALL ChangeLog README TODO
}

pkg_postinst() {
	echo ""
	einfo 'To get help about usage run "$ cue2tracks -h"'
	echo ""
}
