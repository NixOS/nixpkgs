{stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala, python, libsearpc, libzdb, libuuid, libevent, sqlite, openssl}:

stdenv.mkDerivation rec
{
  version = "1.4.2";
  seafileVersion = "4.0.6";
  name = "ccnet-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/ccnet/archive/v${seafileVersion}.tar.gz";
    sha256 = "06srvyphrfx7g18vk899850q0aw8cxx34cj96mjzc3sqm0bkzqsh";
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
    homepage = https://github.com/haiwen/ccnet;
    description = "A framework for writing networked applications in C";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
