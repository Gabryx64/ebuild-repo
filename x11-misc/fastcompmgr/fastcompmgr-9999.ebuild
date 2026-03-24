EAPI=8

inherit toolchain-funcs git-r3
DESCRIPTION="A fast compositor for X11"
HOMEPAGE="https://github.com/tycho-kirchner/fastcompmgr"
EGIT_REPO_URI="https://github.com/tycho-kirchner/fastcompmgr"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="x11-libs/libX11 x11-libs/libXcomposite x11-libs/libXdamage x11-libs/libXfixes x11-libs/libXrender"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/pkgconf"

src_prepare() {
	default
	sed -i -e 's:CFLAGS =:CFLAGS +=:' Makefile \
		|| die "sed fix failed. Uh-oh..."
	sed -i -e 's:LIBS:LDFLAGS:' Makefile \
		|| die "sed fix failed. Uh-oh..."
	sed -i -e 's:LDFLAGS =:LDFLAGS +=:' Makefile \
		|| die "sed fix failed. Uh-oh..."
}

src_compile() {
	env CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		make
}

src_install() {
	dobin fastcompmgr
	doman fastcompmgr.1
}
