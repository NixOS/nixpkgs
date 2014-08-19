{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig, glib, libdaemon
, mpd_clientlib, curl, sqlite, ruby, rubyLibs, libnotify }:

stdenv.mkDerivation rec {
  version = "20130809";
  name    = "mpdcron-${version}";

  src = fetchgit {
    url    = https://github.com/alip/mpdcron.git;
    rev    = "1dd16181c32f33e7754bbe21841c8e70b28f8ecd";
    sha256 = "1h3n433jn9yg74i218pkxzrngsjpnf0z02lakfldl6j1s9di2pn3";
  };

  meta = {
    description = "A cron like daemon for mpd.";
    homepage    = http://alip.github.io/mpdcron/;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = with stdenv.lib.platforms; unix;
    maintainers = [ stdenv.lib.maintainers.lovek323 ];
  };

  buildInputs =
    [ autoconf automake libtool pkgconfig glib libdaemon
      mpd_clientlib curl sqlite ruby rubyLibs.nokogiri libnotify ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--enable-gmodule" "--with-standard-modules=all" ];
}
