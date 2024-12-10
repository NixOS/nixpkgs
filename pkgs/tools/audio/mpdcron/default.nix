{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  pkg-config,
  glib,
  libdaemon,
  libmpdclient,
  curl,
  sqlite,
  bundlerEnv,
  libnotify,
  pandoc,
}:

let
  gemEnv = bundlerEnv {
    name = "mpdcron-bundle";
    gemdir = ./.;
  };
in
stdenv.mkDerivation {
  pname = "mpdcron";
  version = "20161228";

  src = fetchFromGitHub {
    owner = "alip";
    repo = "mpdcron";
    rev = "e49e6049b8693d31887c538ddc7b19f5e8ca476b";
    sha256 = "0vdksf6lcgmizqr5mqp0bbci259k0dj7gpmhx32md41jlmw5skaw";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];
  buildInputs = [
    libtool
    glib
    libdaemon
    pandoc
    libmpdclient
    curl
    sqlite
    gemEnv.wrappedRuby
    libnotify
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--enable-gmodule"
    "--with-standard-modules=all"
  ];

  meta = with lib; {
    description = "A cron like daemon for mpd";
    homepage = "http://alip.github.io/mpdcron/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      lovek323
      manveru
    ];
  };
}
# TODO: autoreconfHook this
