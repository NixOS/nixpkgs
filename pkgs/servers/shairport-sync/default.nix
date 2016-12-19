{ stdenv, fetchFromGitHub, autoreconfHook, openssl, avahi, alsaLib
, libdaemon, popt, pkgconfig, libconfig, libpulseaudio, soxr }:

stdenv.mkDerivation rec {
  version = "2.3.6.5";
  name = "shairport-sync-${version}";

  src = fetchFromGitHub {
    sha256 = "1337y62pnch27s2gr47miip3na1am24xprlc5a27lbr764nr85s3";
    rev = version;
    repo = "shairport-sync";
    owner = "mikebrady";
  };

  buildInputs = [
    autoreconfHook
    openssl
    avahi
    alsaLib
    libdaemon
    pkgconfig
    popt
    libconfig
    libpulseaudio
    soxr
  ];

  enableParallelBuilding = true;

  configureFlags = ''
    --with-alsa --with-pipe --with-pulseaudio --with-stdout
    --with-avahi --with-ssl=openssl --with-soxr
    --without-configfiles --without-initscript
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Airtunes server and emulator with multi-room capabilities";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
