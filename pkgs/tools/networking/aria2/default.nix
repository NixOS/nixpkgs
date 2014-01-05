{ stdenv, fetchurl, pkgconfig, openssl, libxml2, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-1.18.1";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/stable/${name}/${name}.tar.bz2";
    sha256 = "0fwm5d0i4nr9yzckmd8yc80yj4h1acrv6jca3h1vjji0rbgk49zy";
  };

  buildInputs = [ pkgconfig openssl libxml2 sqlite zlib ];

  meta = {
    homepage = http://aria2.sourceforge.net/;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
  };
}
