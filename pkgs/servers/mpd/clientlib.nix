{ stdenv, fetchurl, doxygen }:

stdenv.mkDerivation rec {
  version = "2.8";
  name = "libmpdclient-${version}";
  src = fetchurl {
    url = "http://www.musicpd.org/download/libmpdclient/2/${name}.tar.bz2";
    sha256 = "1qwjkb56rsbk0hwhg7fl15d6sf580a19gh778zcdg374j4yym3hh";
  };

  buildInputs = [ doxygen ];

  meta = {
    description = "Client library for MPD (music player daemon)";
    homepage = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki;
    license = "GPLv2";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}
