{ stdenv, fetchurl, pkgconfig, openssl, libxml2, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-1.18.8";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/stable/${name}/${name}.tar.bz2";
    sha256 = "1lpcdpkc22prkzhqrhrd6ccra6vpf2w8mla0z3jv26dqafaxif6b";
  };

  buildInputs = [ pkgconfig openssl libxml2 sqlite zlib ];

  meta = {
    homepage = http://aria2.sourceforge.net/;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
  };
}
