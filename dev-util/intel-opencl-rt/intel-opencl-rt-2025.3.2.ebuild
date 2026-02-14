# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

MY_PVR="${PV}-832"

DESCRIPTION="Intel CPU OpenCL runtime (oneAPI)"
HOMEPAGE="https://www.intel.com/content/www/us/en/developer/tools/opencl-cpu-runtime/overview.html"
SRC_URI="
	https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-runtime-dpcpp-sycl-opencl-cpu-${MY_PVR}_amd64.deb
	https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-runtime-compilers-${MY_PVR}_amd64.deb
"

S="${WORKDIR}"
LICENSE="Intel-SDP"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	!dev-util/intel-ocl-sdk
	dev-cpp/tbb
	dev-libs/opencl-icd-loader
	virtual/zlib
"
BDEPEND="dev-util/patchelf"

QA_PREBUILT="opt/intel/opencl-rt/*"

src_install() {
	local src=opt/intel/oneapi/redist/lib
	local dest=/opt/intel/opencl-rt/lib

	insinto "${dest}"

	# install Intel OpenCL runtime libs
	doins "${src}"/libintelocl.so.2026.20.1.0
	doins "${src}"/libcommon_clang.so.2026.20.1.0
	dosym libintelocl.so.2026.20.1.0 "${dest}/libintelocl.so"
	dosym libcommon_clang.so.2026.20.1.0 "${dest}/libcommon_clang.so"

	# SVML variants for different CPU microarchitectures
	doins "${src}"/libocl_svml_*.so

	# Intel compiler runtime libs (libimf, libsvml, libirng, libintlc)
	local cmplr_lib
	for cmplr_lib in libimf.so libsvml.so libirng.so libintlc.so.5; do
		doins "${src}/${cmplr_lib}"
	done
	dosym libintlc.so.5 "${dest}/libintlc.so"

	# bitcode, object files, and config
	doins "${src}"/*.rtl "${src}"/*.o

	# fix rpaths and permissions on shared libraries
	local lib
	for lib in "${ED}${dest}"/*.so*; do
		[[ -L "${lib}" || ! -f "${lib}" ]] && continue
		patchelf --set-rpath '$ORIGIN' "${lib}" || die "patchelf failed on $(basename "${lib}")"
		fperms 0755 "${dest}/$(basename "${lib}")"
	done

	# register as OpenCL ICD
	insinto /etc/OpenCL/vendors
	newins - intel-cpu.icd <<< "${dest}/libintelocl.so"
}
