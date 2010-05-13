# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="mysqlreport makes a friendly report of important MySQL status values."
HOMEPAGE="http://hackmysql.com/mysqlreport"
SRC_URI="http://hackmysql.com/scripts/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-perl/DBD-mysql
		virtual/perl-File-Temp
		virtual/perl-Getopt-Long"

src_install() {
	dobin mysqlreport
	dohtml mysqlreportdoc.html mysqlreportguide.html
	prepalldocs
}
