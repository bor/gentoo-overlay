# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit bash-completion-r1

DESCRIPTION="Little git extras"
HOMEPAGE="https://github.com/tj/git-extras"
SRC_URI="https://github.com/tj/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-vcs/git"

DOCS=( AUTHORS Readme.md )

src_compile() {
	:;
	# we skip this because the first target of the
	# Makefile is "install" and plain "make" would
	# actually run "make install"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" SYSCONFDIR="/etc" install
	newbashcomp "${D}/etc/bash_completion.d/${PN}" ${PN}
}
