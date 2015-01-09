{ stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala, python
, libsearpc, libzdb, libuuid, libevent, sqlite, openssl }:

stdenv.mkDerivation rec
{
  version = "4.0.4";
  name = "ccnet-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/ccnet/archive/v${version}.tar.gz";
    sha256 = "15179dxgrnd9nyk7y4fkqhvjjg2k58dxs58zylm90hlb3kyjz0ak";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool vala  python ];
  propagatedBuildInputs = [ libsearpc libzdb libuuid libevent sqlite openssl ];

  preConfigure = ''
  sed -ie 's|/bin/bash|/bin/sh|g' ./autogen.sh
  ./autogen.sh
  '';

  configureFlags = "--enable-server";

  buildPhase = "make -j1";

  meta =
  {
    homepage = "https://github.com/haiwen/ccnet";
    description = "A framework for writing networked applications in C.";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.matejc ];
  };
}
