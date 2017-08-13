{ fetchurl, stdenv, ncurses, curl, pkgconfig, gnutls, readline
, openssl, perl, sqlite, libjpeg, speex, pcre
, ldns, libedit, yasm, which, lua, libopus, libsndfile }:

stdenv.mkDerivation rec {
  name = "freeswitch-1.6.15";

  src = fetchurl {
    url = "http://files.freeswitch.org/freeswitch-releases/${name}.tar.bz2";
    sha256 = "071g7229shr9srwzspx29fcx3ccj3rwakkydpc4vdf1q3lldd2ld";
  };
  postPatch = "patchShebangs libs/libvpx/build/make/rtcd.pl";

  buildInputs = [
    openssl ncurses curl pkgconfig gnutls readline perl libjpeg
    sqlite pcre speex ldns libedit yasm which lua libopus
    libsndfile
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "format" ];

  meta = {
    description = "Cross-Platform Scalable FREE Multi-Protocol Soft Switch";
    homepage = https://freeswitch.org/;
    license = stdenv.lib.licenses.mpl11;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
