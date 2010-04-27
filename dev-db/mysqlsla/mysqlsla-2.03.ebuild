# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-app

DESCRIPTION="mysqlsla (MySQL Statement Log Analyzer) analyzes MySQL slow and general log files."
HOMEPAGE="http://hackmysql.com/mysqlsla"
SRC_URI="http://hackmysql.com/scripts/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-perl/DBD-mysql
		dev-perl/DBI"
