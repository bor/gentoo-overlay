# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

MY_L0_VER="1.5.$(ver_cut 3-4)"

DESCRIPTION="Intel Graphics Compute Runtime for OpenCL/Level Zero (legacy, pre-built)"
HOMEPAGE="https://github.com/intel/compute-runtime"
SRC_URI="
	https://github.com/intel/compute-runtime/releases/download/${PV}/intel-opencl-icd-legacy1_${PV}_amd64.deb
	https://github.com/intel/compute-runtime/releases/download/${PV}/intel-level-zero-gpu-legacy1_${MY_L0_VER}_amd64.deb
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="legacy"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="
	!dev-libs/intel-compute-runtime:0
	>=dev-util/intel-graphics-compiler-legacy-bin-1.0.17537.24
	>=media-libs/gmmlib-22.5.0
	dev-libs/opencl-icd-loader
"

QA_PREBUILT="usr/lib64/*"

src_install() {
	# OpenCL ICD library
	insinto /usr/lib64/intel-opencl
	doins usr/lib/x86_64-linux-gnu/intel-opencl/libigdrcl_legacy1.so
	fperms 0755 /usr/lib64/intel-opencl/libigdrcl_legacy1.so

	# ICD vendor file
	insinto /etc/OpenCL/vendors
	newins - intel_legacy1.icd <<< "/usr/lib64/intel-opencl/libigdrcl_legacy1.so"

	# ocloc compiler tool
	newbin usr/bin/ocloc-24.35.0 ocloc-legacy

	# ocloc support library
	insinto /usr/lib64
	doins usr/lib/x86_64-linux-gnu/libocloc_legacy1.so
	fperms 0755 /usr/lib64/libocloc_legacy1.so

	# Level Zero GPU driver
	doins usr/lib/x86_64-linux-gnu/libze_intel_gpu_legacy1.so.${MY_L0_VER}
	dosym libze_intel_gpu_legacy1.so.${MY_L0_VER} /usr/lib64/libze_intel_gpu_legacy1.so.1
	dosym libze_intel_gpu_legacy1.so.${MY_L0_VER} /usr/lib64/libze_intel_gpu_legacy1.so
	fperms 0755 /usr/lib64/libze_intel_gpu_legacy1.so.${MY_L0_VER}
}
