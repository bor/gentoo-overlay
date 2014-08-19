# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; Bumped by mva; $

EAPI="5"

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="http://syncthing.net/"
SRC_URI="https://github.com/syncthing/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

inherit eutils

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/go
	dev-vcs/git
	dev-vcs/mercurial
"
# dev-vsc things needs for setup phase (godep required it)
RDEPEND="${DEPEND}"

SG="${WORKDIR}/src/github.com/syncthing/syncthing"
export GOPATH="${WORKDIR}"

src_prepare() {
	mkdir -p "${SG}" || die
	mv "${S}/"* "${SG}" || die
	cd "${SG}"

	# TODO move this to package and add as depend
	go get github.com/tools/godep || die
	#go get github.com/mattn/goveralls || die
	#go get code.google.com/p/go.tools/cmd/cover
	#go get code.google.com/p/go.tools/cmd/vet
}

src_compile() {
	cd "${SG}"
	PATH="$PATH:$GOPATH/bin"
	GOBIN="${GOPATH}/bin"
	local version="v${PV}"
	local date=$(date +%s)
	local user=$(whoami)
	local host=$(hostname);	host=${host%%.*};
	local ldflags="-w -X main.Version $version -X main.BuildStamp $date -X main.BuildUser $user -X main.BuildHost $host -X main.BuildEnv $bldenv"
	godep go build -ldflags "$ldflags" ./cmd/syncthing || die
	#godep go install -tags noupgrade -ldflags "$ldflags" ./cmd/... || die
}

src_install() {
	cd "${SG}"
	dobin syncthing || die
	dodoc README.md || die
}
