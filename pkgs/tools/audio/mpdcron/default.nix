{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig, glib, libdaemon
, mpd_clientlib, curl, sqlite, ruby, bundlerEnv, libnotify, pandoc }:

let
  gemEnv = bundlerEnv {
    name = "mpdcron-bundle";
    gemdir = ./.;
  };
in stdenv.mkDerivation rec {
  version = "20130809";
  name    = "mpdcron-${version}";

  src = fetchgit {
    url    = https://github.com/alip/mpdcron.git;
    rev    = "1dd16181c32f33e7754bbe21841c8e70b28f8ecd";
    sha256 = "0ayr9a5f6i4z3wx486dp77ffzs61077b8w871pqr3yypwamcjg6b";
  };

  meta = {
    description = "A cron like daemon for mpd";
    homepage    = http://alip.github.io/mpdcron/;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = with stdenv.lib.platforms; unix;
    maintainers = [ stdenv.lib.maintainers.lovek323 ];
  };

  buildInputs =
    [ autoconf automake libtool pkgconfig glib libdaemon pandoc
      mpd_clientlib curl sqlite ruby gemEnv libnotify ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--enable-gmodule" "--with-standard-modules=all" ];
}
