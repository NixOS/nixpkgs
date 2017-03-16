{stdenv, fetchurl, which, automake, autoconf, pkgconfig, libtool, vala, python, libsearpc, libzdb, libuuid, libevent, sqlite, openssl}:

stdenv.mkDerivation rec
{
  version = "5.1.4";
  name = "ccnet-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/ccnet/archive/v${version}-server.tar.gz";
    sha256 = "0k1wn58kxx1llb4siavas3krmz0lm1a25wk0hh5c173isj03lac9";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool vala python ];
  propagatedBuildInputs = [ libsearpc libzdb libuuid libevent sqlite openssl ];

  preConfigure = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  configureFlags = "--enable-server --disable-compile-demo";

  buildPhase = "make -j1";

  meta =
  {
    homepage = https://github.com/haiwen/ccnet;
    description = "A framework for writing networked applications in C";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
