{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl_1_1
, avahi
, alsa-lib
, libplist
, glib
, libdaemon
, libsodium
, libgcrypt
, ffmpeg
, libuuid
, unixtools
, popt
, libconfig
, libpulseaudio
, libjack2
, pipewire
, soxr
, enableAirplay2 ? false
, enableStdout ? true
, enableAlsa ? true
, enablePulse ? true
, enablePipe ? true
, enablePipewire ? true
, enableJack ? true
, enableMetadata ? false
, enableMpris ? stdenv.isLinux
, enableDbus ? stdenv.isLinux
, enableSoxr ? true
, enableLibdaemon ? false
}:

stdenv.mkDerivation rec {
  version = "4.1.1";
  pname = "shairport-sync";

  src = fetchFromGitHub {
    rev = version;
    repo = "shairport-sync";
    owner = "mikebrady";
    hash = "sha256-EKt5mH9GmzeR4zdPDFOt26T9STpG1khVrY4DFIv5Maw=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = with lib; [
    openssl_1_1
    avahi
    popt
    libconfig
  ]
  ++ optional enableLibdaemon libdaemon
  ++ optional enableAlsa alsa-lib
  ++ optional enablePulse libpulseaudio
  ++ optional enablePipewire pipewire
  ++ optional enableJack libjack2
  ++ optional enableSoxr soxr
  ++ optionals enableAirplay2 [
    libplist
    libsodium
    libgcrypt
    libuuid
    ffmpeg
    unixtools.xxd
  ]
  ++ optional stdenv.isLinux glib;

  postPatch = ''
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' dbus-service.c
    sed -i -e 's/G_BUS_TYPE_SYSTEM/G_BUS_TYPE_SESSION/g' mpris-service.c
  '';

  enableParallelBuilding = true;

  configureFlags = with lib; [
    "--without-configfiles"
    "--sysconfdir=/etc"
    "--with-ssl=openssl"
    "--with-stdout"
    "--with-avahi"
  ]
  ++ optional enablePulse "--with-pa"
  ++ optional enablePipewire "--with-pw"
  ++ optional enableAlsa "--with-alsa"
  ++ optional enableJack "--with-jack"
  ++ optional enableStdout "--with-stdout"
  ++ optional enablePipe "--with-pipe"
  ++ optional enableSoxr "--with-soxr"
  ++ optional enableDbus "--with-dbus-interface"
  ++ optional enableMetadata "--with-metadata"
  ++ optional enableMpris "--with-mpris-interface"
  ++ optional enableLibdaemon "--with-libdaemon"
  ++ optional enableAirplay2 "--with-airplay-2";

  meta = with lib; {
    homepage = "https://github.com/mikebrady/shairport-sync";
    description = "Airtunes server and emulator with multi-room capabilities";
    license = licenses.mit;
    maintainers = with maintainers; [ lnl7 jordanisaacs ];
    platforms = platforms.unix;
  };
}
