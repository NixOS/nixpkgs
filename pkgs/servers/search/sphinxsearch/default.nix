{ stdenv, fetchurl, pkgconfig,
  version ? "2.2.8",
  mainSrc ? fetchurl {
    url = "http://sphinxsearch.com/files/sphinx-${version}-release.tar.gz";
    sha256 = "1q6jdw5g81k7ciw9fhwklb5ifgb8zna39795m0x0lbvwjbk3ampv";
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
