{ stdenv, fetchurl, pkgconfig, openssl, libxml2, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-1.17.1";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/stable/${name}/${name}.tar.bz2";
    sha256 = "0v0cdbv6v7fb4870rz5s9vscsj74fzbj70gsa2y4hysai4a0im3y";
  };

  buildInputs = [ pkgconfig openssl libxml2 sqlite zlib ];

  meta = {
    homepage = http://aria2.sourceforge.net/;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
  };
}
