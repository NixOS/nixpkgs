{ stdenv, fetchurl, mpd_clientlib, curl, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "mpdscribble-${version}";
  version = "0.22";

  src = fetchurl {
    url =
    "http://www.musicpd.org/download/mpdscribble/${version}/mpdscribble-${version}.tar.bz2";
    sha256 = "0hgb7xh3w455m00lpldwkyrc5spjn3q1pl2ry3kf7w3hiigjpphw";
  };

  buildInputs = [ mpd_clientlib curl glib pkgconfig ];

  preConfigure = ''
    export LIBMPDCLIENT_LIBS=${mpd_clientlib}/lib/libmpdclient.so.${mpd_clientlib.majorVersion}.0.${mpd_clientlib.minorVersion}
    export LIBMPDCLIENT_CFLAGS=${mpd_clientlib}
  '';

  meta = with stdenv.lib; {
    description = "A Music Player Daemon (MPD) client which submits information about tracks beeing played to a scrobbler (e.g. last.fm)";
    homepage = http://mpd.wikia.com/wiki/Client:mpdscribble;
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
  };
}
