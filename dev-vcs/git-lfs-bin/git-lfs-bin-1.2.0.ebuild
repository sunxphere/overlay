# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

GIT_LFS_URI="https://github.com/github/git-lfs/releases/download/"

DESCRIPTION="Git extension for versioning large files"
HOMEPAGE="https://git-lfs.github.com/"
SRC_URI="amd64? ( ${GIT_LFS_URI%/}/v${PV}/git-lfs-linux-amd64-${PV}.tar.gz -> ${PN}_x86_64-${PV}.tar.gz )
	x86? ( ${GIT_LFS_URI%/}/v${PV}/git-lfs-linux-386-${PV}.tar.gz -> ${PN}_i686-${PV}.tar.gz )"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-vcs/git"
RDEPEND="${DEPEND}"

S="${WORKDIR}/git-lfs-${PV}"

src_install() {
	dobin git-lfs
}

pkg_postinst() {
	elog "Run 'git lfs install' before the first time."
}
