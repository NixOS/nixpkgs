{ stdenv, fetchurl, pkgconfig,
  version ? "2.2.11",
  mainSrc ? fetchurl {
    url = "http://sphinxsearch.com/files/sphinx-${version}-release.tar.gz";
    sha256 = "1aa1mh32y019j8s3sjzn4vwi0xn83dwgl685jnbgh51k16gh6qk6";
  }
}:

stdenv.mkDerivation rec {
  name = "sphinxsearch-${version}";
  src = mainSrc;

  configureFlags = [
    "--program-prefix=sphinxsearch-"
    "--without-mysql"
    "--enable-id64"
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  meta = {
    description = "An open source full text search server";
    homepage    = http://sphinxsearch.com;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ ederoyd46 ];
  };
}
