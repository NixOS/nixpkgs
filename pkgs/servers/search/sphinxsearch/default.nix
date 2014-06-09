{ stdenv, fetchurl, pkgconfig, mysql }:

let
  version = "2.1.8";
  mainSrc = fetchurl {
    url = "http://sphinxsearch.com/files/sphinx-${version}-release.tar.gz";
    sha256 = "8aebff8b00ec07b71790a67781c80a9a9b3ee28e2a35b226663aaf37cb78b6db";
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
    description = "Sphinx is an open source full text search server, designed from the ground up with performance, relevance (aka search quality), and integration simplicity in mind. It's written in C++ and works on Linux (RedHat, Ubuntu, etc), Windows, MacOS, Solaris, FreeBSD, and a few other systems.";
    homepage    = http://sphinxsearch.com;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ ederoyd46 ];
  };
}
