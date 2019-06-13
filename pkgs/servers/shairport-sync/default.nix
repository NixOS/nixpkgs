{ stdenv, fetchFromGitHub, autoreconfHook, openssl, avahi, alsaLib
, libdaemon, popt, pkgconfig, libconfig, libpulseaudio, soxr }:

stdenv.mkDerivation rec {
  version = "3.3";
  name = "shairport-sync-${version}";

  src = fetchFromGitHub {
    sha256 = "0d3cvf408i2rm5h21z264gs8mqdnwavqrwhrkcvypv8gs5rcdw2z";
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

  configureFlags = [
    "--with-alsa" "--with-pipe" "--with-pa" "--with-stdout"
    "--with-avahi" "--with-ssl=openssl" "--with-soxr"
    "--without-configfiles"
    "--sysconfdir=/etc"
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Airtunes server and emulator with multi-room capabilities";
    license = licenses.mit;
    maintainers =  with maintainers; [ lnl7 ];
    platforms = platforms.unix;
  };
}
