{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, openssl, avahi, alsa-lib, glib, libdaemon, popt, libconfig, libpulseaudio, soxr
, enableDbus ? stdenv.isLinux
, enableMetadata ? false
, enableMpris ? stdenv.isLinux
}:

with lib;
stdenv.mkDerivation rec {
  version = "3.3.9";
  pname = "shairport-sync";

  src = fetchFromGitHub {
    sha256 = "sha256-JLgnsLjswj0qus1Vd5ZtPQbbIp3dp2pI7OfQG4JrdW8=";
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
  ] ++ optional stdenv.isLinux glib;

  prePatch = ''
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' dbus-service.c
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' mpris-service.c
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--with-alsa" "--with-pipe" "--with-pa" "--with-stdout"
    "--with-avahi" "--with-ssl=openssl" "--with-soxr"
    "--without-configfiles"
    "--sysconfdir=/etc"
  ]
    ++ optional enableDbus "--with-dbus-interface"
    ++ optional enableMetadata "--with-metadata"
    ++ optional enableMpris "--with-mpris-interface";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Airtunes server and emulator with multi-room capabilities";
    license = licenses.mit;
    maintainers =  with maintainers; [ lnl7 ];
    platforms = platforms.unix;
  };
}
