# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/protobuf/protobuf-2.6.1-r3.ebuild,v 1.1 2015/03/10 21:11:02 vapier Exp $

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
#JAVA_PKG_IUSE="source"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit autotools-multilib eutils flag-o-matic toolchain-funcs distutils-r1 elisp-common versionator

DESCRIPTION="Google's Protocol Buffers -- an efficient method of encoding structured data"
HOMEPAGE="http://code.google.com/p/protobuf/ https://github.com/google/protobuf/"
# https://github.com/google/protobuf/releases/download/v3.0.0-beta-2/protobuf-cpp-3.0.0-beta-2.tar.gz

MY_PV=$(replace_version_separator 3 '-' )
MY_PV=${MY_PV/beta/beta-}
MY_P="${PN}-cpp-${MY_PV}"
SRC_URI="https://github.com/google/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3/2" # subslot = soname major version
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="zlib cpp java python javanano ruby"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	#AUTOTOOLS_AUTORECONF=true
	#append-cxxflags -DGOOGLE_PROTOBUF_NO_RTTI
	autotools-multilib_src_prepare
}

src_configure() {
	DIST_LANG=""

	if [ -z "`use cpp`"]; then
		DIST_LANG="${DIST_LANG} cpp"
	fi

    if [ -z "`use java`"]; then
        DIST_LANG="${DIST_LANG} java"
    fi

    if [ -z "`use python`"]; then
        DIST_LANG="${DIST_LANG} python"
    fi

    if [ -z "`use javanano`"]; then
        DIST_LANG="${DIST_LANG} javanano"
    fi

    if [ -z "`use ruby`"]; then
        DIST_LANG="${DIST_LANG} ruby"
    fi

	local myeconfargs=(
		DIST_LANG=cpp
		$(use_with zlib)
	)

	if tc-is-cross-compiler; then
		# The build system wants `protoc` when building, so we need a copy that
		# runs on the host.  This is more hermetic than relying on the version
		# installed in the host being the exact same version.
		mkdir -p "${WORKDIR}"/build || die
		pushd "${WORKDIR}"/build >/dev/null
		ECONF_SOURCE=${S} econf_build "${myeconfargs[@]}"
		myeconfargs+=( --with-protoc="${PWD}"/src/protoc )
		popd >/dev/null
	fi
	
	autotools-multilib_src_configure
}

multilib_src_compile() {
    echo "Current workdir: "${BUILD_DIR}
	dodir ${BUILD_DIR}/src/google/stubs
	default
}

multilib-minimal_abi_src_compile() {
    echo "Current workdir: "${BUILD_DIR}
    dodir ${BUILD_DIR}/src/google/stubs
    default
}

src_compile() {
	if tc-is-cross-compiler; then
		emake -C "${WORKDIR}"/build/src protoc
	fi

	autotools-multilib_src_compile
}

src_test() {
	autotools-multilib_src_test check
}

src_install() {
	autotools-multilib_src_install
	dodoc CHANGES.txt CONTRIBUTORS.txt README.md
}
