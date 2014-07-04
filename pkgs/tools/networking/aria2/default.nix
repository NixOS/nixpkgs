{ stdenv, fetchurl, pkgconfig, openssl, libxml2, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-1.18.5";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/stable/${name}/${name}.tar.bz2";
    sha256 = "0gyfp4zw7rlaxcxhb402azazf1fi83kk3qg4w0j8d2i7pfa1zqi5";
  };

  buildInputs = [ pkgconfig openssl libxml2 sqlite zlib ];

  meta = {
    homepage = http://aria2.sourceforge.net/;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
  };
}
