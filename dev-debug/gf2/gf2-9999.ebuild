EAPI=8

inherit toolchain-funcs git-r3
DESCRIPTION="A GDB frontend for Lïnux"
HOMEPAGE="https://github.com/nakst/gf"
EGIT_REPO_URI="https://github.com/nakst/gf"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="dev-debug/gdb x11-libs/libX11"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default

	sed -i -e 's:g++:${CXX} ${CPPFLAGS} ${LDFLAGS}:' build.sh \
		|| die "sed fix failed. Uh-oh..."
	sed -i -e 's:-02::' build.sh \
		|| die "sed fix failed. Uh-oh..."
}

src_compile() {
	env CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		./build.sh
}

src_install() {
	dobin gf2
}
