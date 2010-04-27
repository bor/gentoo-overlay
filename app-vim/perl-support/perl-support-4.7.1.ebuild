# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

VIM_PLUGIN_SRC_ID=12819
inherit vim-plugin

DESCRIPTION="vim plugin: Perl-IDE - Write and run Perl scripts using menus and hotkeys"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=556"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=${VIM_PLUGIN_SRC_ID}
		-> ${P}.zip"

LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""
S=${WORKDIR}

VIM_PLUGIN_HELPTEXT="This plugin provides a Perl IDE in vim."
