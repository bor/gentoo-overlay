# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Intel Graphics Compiler for OpenCL (legacy platforms, pre-built)"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI="
	https://github.com/intel/intel-graphics-compiler/releases/download/igc-${PV}/intel-igc-core_${PV}_amd64.deb
	https://github.com/intel/intel-graphics-compiler/releases/download/igc-${PV}/intel-igc-media_${PV}_amd64.deb
	https://github.com/intel/intel-graphics-compiler/releases/download/igc-${PV}/intel-igc-opencl_${PV}_amd64.deb
	https://github.com/intel/intel-graphics-compiler/releases/download/igc-${PV}/intel-igc-opencl-devel_${PV}_amd64.deb
"
S="${WORKDIR}"

LICENSE="MIT Apache-2.0-with-LLVM-exceptions"
SLOT="legacy"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="
	!dev-util/intel-graphics-compiler:0
	virtual/zlib
"

QA_PREBUILT="usr/lib64/*"

src_install() {
	# libraries from igc-core: libigc, libiga64
	insinto /usr/lib64
	doins usr/local/lib/libigc.so.${PV}
	doins usr/local/lib/libiga64.so.${PV}
	dosym libigc.so.${PV} /usr/lib64/libigc.so.1
	dosym libigc.so.${PV} /usr/lib64/libigc.so
	dosym libiga64.so.${PV} /usr/lib64/libiga64.so.1
	dosym libiga64.so.${PV} /usr/lib64/libiga64.so
	fperms 0755 /usr/lib64/libigc.so.${PV}
	fperms 0755 /usr/lib64/libiga64.so.${PV}

	# libraries from igc-opencl: libigdfcl, libopencl-clang
	doins usr/local/lib/libigdfcl.so.${PV}
	doins usr/local/lib/libopencl-clang.so.14
	dosym libigdfcl.so.${PV} /usr/lib64/libigdfcl.so.1
	dosym libigdfcl.so.${PV} /usr/lib64/libigdfcl.so
	dosym libopencl-clang.so.14 /usr/lib64/libopencl-clang.so
	fperms 0755 /usr/lib64/libigdfcl.so.${PV}
	fperms 0755 /usr/lib64/libopencl-clang.so.14

	# binaries from igc-media
	dobin usr/local/bin/GenX_IR
	dobin usr/local/bin/iga64

	# headers from igc-opencl-devel
	insinto /usr/include/igc
	doins -r usr/local/include/igc/*
	insinto /usr/include/iga
	doins -r usr/local/include/iga/*
	insinto /usr/include
	doins usr/local/include/opencl-c.h
	doins usr/local/include/opencl-c-base.h
	insinto /usr/include/visa
	doins -r usr/local/include/visa/*

	# pkgconfig
	insinto /usr/lib64/pkgconfig
	doins usr/local/lib/pkgconfig/igc-opencl.pc
	sed -i 's|/usr/local|/usr|' "${ED}/usr/lib64/pkgconfig/igc-opencl.pc" || die

	# license
	insinto /usr/share/licenses/${PN}
	doins usr/local/lib/igc/NOTICES.txt
}
