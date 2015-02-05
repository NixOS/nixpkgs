{ stdenv, fetchurl, pkgconfig, openssl, libxml2, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.18.9";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/stable/${name}/${name}.tar.bz2";
    sha256 = "1cn4g4mcrnw67y23970a9bngl8nf2x9hh82lc59gz3xyxn8wljz2";
  };

  buildInputs = [ pkgconfig openssl libxml2 sqlite zlib ];

  meta = with stdenv.lib; {
    homepage = http://aria2.sourceforge.net/;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    maintainers = [ maintainers.koral ];
    license = licenses.gpl2Plus;
  };
}
