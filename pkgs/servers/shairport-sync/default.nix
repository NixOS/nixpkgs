{ stdenv, fetchFromGitHub, autoreconfHook, openssl, avahi, alsaLib
, libdaemon, popt, pkgconfig, libconfig, libpulseaudio, soxr }:

stdenv.mkDerivation rec {
  version = "3.2";
  name = "shairport-sync-${version}";

  src = fetchFromGitHub {
    sha256 = "07b0g5iyjmqyq6zxx5mv72kri66jw6wv6i3gzax6jhkdiag06lwm";
    rev = version;
    repo = "shairport-sync";
    owner = "mikebrady";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [
    openssl
    avahi
    alsaLib
    libdaemon
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
    maintainers =  with maintainers; [ lnl7 ];
    platforms = platforms.unix;
  };
}
