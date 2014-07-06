{ stdenv, fetchurl, pkgconfig, mysql }:

let
  version = "2.1.9";
  mainSrc = fetchurl {
    url = "http://sphinxsearch.com/files/sphinx-${version}-release.tar.gz";
    sha256 = "00vwxf3zr0g1fq9mls1z2rd8nxw74b76pkl1j466lig1qc5am2b2";
  };
in

stdenv.mkDerivation rec {
  name = "sphinxsearch-${version}";
  src = mainSrc;

  configureFlags = [
    "--program-prefix=sphinxsearch-"
  ];

  buildInputs = [ 
    pkgconfig
    mysql
  ];

  meta = {
    description = "Sphinx is an open source full text search server.";
    homepage    = http://sphinxsearch.com;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ ederoyd46 ];
  };
}
