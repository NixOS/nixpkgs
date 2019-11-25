{ stdenv, fetchFromGitHub, autoreconfHook, openssl, avahi, alsaLib
, libdaemon, popt, pkgconfig, libconfig, libpulseaudio, soxr }:

stdenv.mkDerivation rec {
  version = "3.3.4";
  pname = "shairport-sync";

  src = fetchFromGitHub {
    sha256 = "07rxf1la93g5y7yq49fglhxji8vizzr268p1ccf8ws8j025vbl7n";
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
