{ stdenv, fetchurl, unzip, autoconf, automake, libtool, libpo6, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libe-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "https://github.com/rescrv/e/archive/releases/0.8.1.zip";
    sha256 = "1l13axsi52j2qaxbdnszdvfxksi7rwm2j1rrf0nlh990m6a3yg3s";
  };
  buildInputs = [ unzip autoconf automake libtool libpo6 pkgconfig ];
  preConfigure = "autoreconf -i";

  meta = with stdenv.lib; {
    description = "Library containing high-performance datastructures and utilities for C++";
    homepage = https://github.com/rescrv/e;
    license = licenses.bsd3;
  };
}
