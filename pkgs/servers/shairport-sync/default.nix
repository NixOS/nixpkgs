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
  version = "4.3.4";

  src = fetchFromGitHub {
    repo = "shairport-sync";
    owner = "mikebrady";
    rev = "refs/tags/${version}";
    hash = "sha256:1y8dh1gdffq38hgy6x1228l51l6p56iaiqlflw7w1dcbgw15llcd";
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
  ] ++ optional enableAirplay2 [
    unixtools.xxd
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

  meta = {
    homepage = "https://github.com/mikebrady/shairport-sync";
    description = "Airtunes server and emulator with multi-room capabilities";
    license = lib.licenses.mit;
    mainProgram = "shairport-sync";
    maintainers = with lib.maintainers; [ lnl7 jordanisaacs ];
    platforms = lib.platforms.unix;
  };
}
