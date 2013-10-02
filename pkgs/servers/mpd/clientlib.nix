{ stdenv, fetchurl, doxygen }:

stdenv.mkDerivation rec {
  version = "${passthru.majorVersion}.${passthru.minorVersion}";
  name = "libmpdclient-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/libmpdclient/2/${name}.tar.bz2";
    sha256 = "1qwjkb56rsbk0hwhg7fl15d6sf580a19gh778zcdg374j4yym3hh";
  };

  buildInputs = [ doxygen ];

  passthru = {
    majorVersion = "2";
    minorVersion = "8";
  };

  meta = {
    description = "Client library for MPD (music player daemon)";
    homepage = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki;
    license = "GPLv2";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}
