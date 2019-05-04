{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, glib, libdaemon
, mpd_clientlib, curl, sqlite, ruby, bundlerEnv, libnotify, pandoc }:

let
  gemEnv = bundlerEnv {
    name = "mpdcron-bundle";
    gemdir = ./.;
  };
in stdenv.mkDerivation rec {
  version = "20161228";
  name    = "mpdcron-${version}";

  src = fetchFromGitHub {
    owner = "alip";
    repo = "mpdcron";
    rev = "e49e6049b8693d31887c538ddc7b19f5e8ca476b";
    sha256 = "0vdksf6lcgmizqr5mqp0bbci259k0dj7gpmhx32md41jlmw5skaw";
  };

  meta = with stdenv.lib; {
    description = "A cron like daemon for mpd";
    homepage    = http://alip.github.io/mpdcron/;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ lovek323 manveru ];
  };

  buildInputs =
    [ autoconf automake libtool pkgconfig glib libdaemon pandoc
      mpd_clientlib curl sqlite gemEnv.wrappedRuby libnotify ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--enable-gmodule" "--with-standard-modules=all" ];
}
