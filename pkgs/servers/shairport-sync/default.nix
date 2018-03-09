{ stdenv, fetchFromGitHub, autoreconfHook, openssl, avahi, alsaLib
, libdaemon, popt, pkgconfig, libconfig, libpulseaudio, soxr }:

stdenv.mkDerivation rec {
  version = "3.1.7";
  name = "shairport-sync-${version}";

  src = fetchFromGitHub {
    sha256 = "1ip8vlyly190fhcd55am5xvqisvch8mnw50xwbm663dapdb1f8ys";
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
