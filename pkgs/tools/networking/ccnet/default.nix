{stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala, python, libsearpc, libzdb, libuuid, libevent, sqlite, openssl}:

stdenv.mkDerivation rec
{
  version = "1.4.2";
  seafileVersion = "3.0.4";
  name = "ccnet-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/ccnet/archive/v${seafileVersion}.tar.gz";
    sha256 = "1y9x6k9ql8bj83016a1mi1m5ixxh8fm7p4qbd5mslnamvjln171q";
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
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
