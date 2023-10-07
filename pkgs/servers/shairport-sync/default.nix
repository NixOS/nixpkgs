{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl
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

let
  inherit (lib) optional optionals;
in

stdenv.mkDerivation rec {
  pname = "shairport-sync";
  version = "4.3.1";

  src = fetchFromGitHub {
    repo = "shairport-sync";
    owner = "mikebrady";
    rev = "refs/tags/${version}";
    hash = "sha256-Yj0SKMKACj2B/ADPkUzO4EvaYZX39erKmjaTsr5UN0s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    # For glib we want the `dev` output for the same library we are
    # also linking against, since pkgsHostTarget.glib.dev exposes
    # some extra tools that are built for build->host execution.
    # To achieve this, we coerce the output to a string to prevent
    # mkDerivation's splicing logic from kicking in.
    "${glib.dev}"
  ];

  makeFlags = [
    # Workaround for https://github.com/mikebrady/shairport-sync/issues/1705
    "AR=${stdenv.cc.bintools.targetPrefix}ar"
  ];

  buildInputs = [
    openssl
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

  configureFlags = [
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

  strictDeps = true;

  meta = with lib; {
    homepage = "https://github.com/mikebrady/shairport-sync";
    description = "Airtunes server and emulator with multi-room capabilities";
    license = licenses.mit;
    maintainers = with maintainers; [ lnl7 jordanisaacs ];
    platforms = platforms.unix;
  };
}
