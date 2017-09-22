{stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala_0_23, python, libsearpc, libzdb, libuuid, libevent, sqlite, openssl}:

stdenv.mkDerivation rec
{
  version = "6.1.0";
  seafileVersion = "6.1.0";
  name = "ccnet-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/ccnet/archive/v${version}.tar.gz";
    sha256 = "0q4a102xlcsxlr53h4jr4w8qzkbzvm2f3nk9fsha48h6l2hw34bb";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool vala_0_23 python ];
  propagatedBuildInputs = [ libsearpc libzdb libuuid libevent sqlite openssl ];

  preConfigure = ''
  sed -ie 's|/bin/bash|${stdenv.shell}|g' ./autogen.sh
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
