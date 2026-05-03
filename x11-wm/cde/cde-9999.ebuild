# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic git-r3

DESCRIPTION="The Common Desktop Environment, the classic UNIX desktop"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv/"
EGIT_REPO_URI="https://git.code.sf.net/p/cdesktopenv/code"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${P}/cde"

# Based on upstream LinuxBuild wiki + old cde-9999 ebuild deps
# https://sourceforge.net/p/cdesktopenv/wiki/LinuxBuild/
DEPEND="
  x11-libs/libXt
  x11-libs/libXmu
  x11-libs/libXft
  x11-libs/libXinerama
  x11-libs/libXpm
  >=x11-libs/motif-2.3
  x11-libs/libXaw
  x11-libs/libX11
  x11-libs/libXScrnSaver
  x11-libs/libXrender
  net-libs/libtirpc
  net-libs/rpcsvc-proto

  x11-apps/xset
  x11-apps/xrdb
  x11-apps/sessreg
  x11-misc/xbitmaps

  virtual/jpeg
  media-libs/freetype:2

  dev-lang/tcl
  app-shells/ksh
  app-arch/ncompress
  app-text/opensp

  dev-libs/openssl:0=
  sys-libs/libutempter
  dev-db/lmdb

  sys-libs/pam
  net-nds/rpcbind

  media-fonts/font-adobe-100dpi
  media-fonts/font-adobe-utopia-100dpi
  media-fonts/font-bh-100dpi
  media-fonts/font-bh-lucidatypewriter-100dpi
  media-fonts/font-bitstream-100dpi
"
RDEPEND="${DEPEND}"

src_prepare() {
  append-flags "-Wno-incompatible-pointer-types"
  default

  # 2.5.x series uses autotools; autogen.sh is the canonical entry point.
  if [[ -x ./autogen.sh ]]; then
    einfo "Running upstream autogen.sh"
    ./autogen.sh || die "autogen.sh failed"
  fi
}

src_configure() {
  append-cflags "-std=gnu99"
  # Upstream defaults already install into /usr/dt and expect
  # startx /usr/dt/bin/Xsession, so we don't try to FHS-relocate here.
  econf \
    --sysconfdir=/etc \
    --localstatedir=/var
}

src_compile() {
  append-cflags "-std=gnu99"

  # Nothing special required; autotools build
  default
}

src_install() {
  default

  # These are recommended/assumed by upstream docs
  # /var/dt is used by various CDE daemons; historically world-writable.
  dodir /var/dt
  fperms 0777 /var/dt || die

  # Calendar manager spool dir (used by dtcm/rpc.cmsd, even if buggy)
  dodir /usr/spool/calendar
}

pkg_postinst() {
  elog "To start CDE for a single user:"
  elog "  startx /usr/dt/bin/Xsession"
  elog
  elog "For dtlogin (graphical login manager), see the upstream LinuxBuild wiki:"
  elog "  https://sourceforge.net/p/cdesktopenv/wiki/LinuxBuild/"
  elog
  elog "Some CDE components (ToolTalk, calendar manager, etc.) require rpcbind."
  elog "Ensure the rpcbind service is running before using those applications."
  elog
  elog "CDE 2.5.x no longer *requires* rpcbind's insecure '-i' mode, so you"
  elog "should not enable that unless you know you need it and understand the"
  elog "security implications."
}

