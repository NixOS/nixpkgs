{ fetchurl, stdenv, ncurses, curl, pkgconfig, gnutls, readline
, openssl, perl, sqlite, libjpeg, speex, pcre
, ldns, libedit, yasm, which, lua, libopus, libsndfile

, SystemConfiguration
}:

stdenv.mkDerivation rec {
  name = "freeswitch-1.6.20";

  src = fetchurl {
    url = "https://files.freeswitch.org/freeswitch-releases/${name}.tar.bz2";
    sha256 = "0hqz68abs5x5vzf1mndcvdi35nrhmnklzdrnrk8dyvzvz67hp2ah";
  };
  postPatch = ''
    patchShebangs     libs/libvpx/build/make/rtcd.pl
    substituteInPlace libs/libvpx/build/make/configure.sh \
      --replace AS=\''${AS} AS=yasm
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    openssl ncurses curl gnutls readline perl libjpeg
    sqlite pcre speex ldns libedit yasm which lua libopus
    libsndfile
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "format" ];

  meta = {
    description = "Cross-Platform Scalable FREE Multi-Protocol Soft Switch";
    homepage = https://freeswitch.org/;
    license = stdenv.lib.licenses.mpl11;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
