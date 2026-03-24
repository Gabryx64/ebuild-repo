EAPI=8

inherit toolchain-funcs git-r3
DESCRIPTION="A simple C microframework "
HOMEPAGE="https://git.bwaaa.monster/beaker/about"
EGIT_REPO_URI="https://git.bwaaa.monster/beaker"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="dev-libs/libxml2 dev-libs/beaker"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	sed -i -e 's/CFLAGS :=/CFLAGS +=/' Makefile \
		|| die "sed fix failed. Uh-oh..."
	sed -i -e 's/LDFLAGS :=/LDFLAGS +=/' Makefile \
		|| die "sed fix failed. Uh-oh..."
}

src_compile() {
	env CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		make
}

src_install() {
	dolib.a build/libbeaker.a
	dolib.so build/libbeaker.so
	doheader beaker.h
}
