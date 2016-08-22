{stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala_0_23, python, libsearpc, libzdb, libuuid, libevent, sqlite, openssl}:

stdenv.mkDerivation rec
{
  version = "5.0.7";
  seafileVersion = "5.0.7";
  name = "ccnet-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/ccnet/archive/v${version}.tar.gz";
    sha256 = "1e1c670a85619b174328a15925a050c7a8b323fecd13434992332f5c15e05de1";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool vala_0_23 python ];
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
