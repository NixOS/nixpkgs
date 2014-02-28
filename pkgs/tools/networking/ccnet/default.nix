{stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala, python, libsearpc, libzdb, libuuid, libevent, sqlite, openssl}:

stdenv.mkDerivation rec
{
  version = "1.4.0";
  seafileVersion = "2.1.1";
  name = "ccnet-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/ccnet/archive/v${seafileVersion}.tar.gz";
    sha256 = "6882eb1a3066897e4f91fb60a3405b3f58b4b794334deaca73617003f77a7eb0";
  };

  patches = [ ./libccnet.pc.patch ./0001-Add-autoconfiguration-for-libjansson.patch ];

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
