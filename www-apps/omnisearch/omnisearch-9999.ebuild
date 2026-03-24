EAPI=8

inherit toolchain-funcs git-r3
DESCRIPTION="A modern lightweight metasearch engine with a clean design written in C"
HOMEPAGE="https://git.bwaaa.monster/omnisearch/about"
EGIT_REPO_URI="https://git.bwaaa.monster/omnisearch"

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
	sed -i -e 's:output_log="/var/log/omnisearch/omnisearch.log"::' init/openrc/omnisearch \
		|| die "sed fix failed. Uh-oh..."
	sed -i -e 's:error_log="/var/log/omnisearch/omnisearch.err"::' init/openrc/omnisearch \
		|| die "sed fix failed. Uh-oh..."
	sed -i -e 's:user=omnisearch::' init/openrc/omnisearch \
		|| die "sed fix failed. Uh-oh..."
	sed -i -e 's:group=omnisearch::' init/openrc/omnisearch \
		|| die "sed fix failed. Uh-oh..."
}

src_compile() {
	env CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		make
}

src_install() {
	insinto /etc/omnisearch
	doins -r templates
	doins -r static

	newins example-config.ini config.ini
	dobin bin/omnisearch
	doinitd init/openrc/omnisearch
}
