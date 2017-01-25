{ fetchurl, stdenv, ncurses, curl, pkgconfig, gnutls, readline
, openssl, perl, sqlite, libjpeg, libzrtpcpp, speex, pcre
, ldns, libedit, yasm, which, lua, libopus, libsndfile }:

stdenv.mkDerivation rec {
  name = "freeswitch-1.6.9";

  src = fetchurl {
    url = "http://files.freeswitch.org/freeswitch-releases/${name}.tar.bz2";
    sha256 = "0g0x4m8rb2ybpxwrszb4w37rb10v9fbszm7l2skjakf4dx0gw5i7";
  };
  postPatch = "patchShebangs libs/libvpx/build/make/rtcd.pl";

  buildInputs = [
    ncurses curl pkgconfig gnutls readline openssl perl libjpeg
    sqlite libzrtpcpp pcre speex ldns libedit yasm which lua libopus
    libsndfile
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "format" ];

  meta = {
    description = "Cross-Platform Scalable FREE Multi-Protocol Soft Switch";
    homepage = http://freeswitch.org/;
    license = stdenv.lib.licenses.mpl11;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
