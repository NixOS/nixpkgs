{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl, avahi, alsa-lib
, libdaemon, popt, pkg-config, libconfig, libpulseaudio, soxr }:

stdenv.mkDerivation rec {
  version = "3.3.7";
  pname = "shairport-sync";

  src = fetchFromGitHub {
    sha256 = "110k196y62zy6cmdvcnf74iamqj7jq0ybnqh1q1irjak81s3yz12";
    rev = version;
    repo = "shairport-sync";
    owner = "mikebrady";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    openssl
    avahi
    alsa-lib
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

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Airtunes server and emulator with multi-room capabilities";
    license = licenses.mit;
    maintainers =  with maintainers; [ lnl7 ];
    platforms = platforms.unix;
  };
}
