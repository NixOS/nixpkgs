{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmpdclient-2.6";
  src = fetchurl {
    url = "mirror://sourceforge/musicpd/${name}.tar.bz2";
    sha256 = "1j8kn0fawdsvczrkhf6xm2yp0h6w49b326i3c08zwvhskd3phljw";
  };

  meta = {
    description = "Client library for MPD (music player daemon)";
    homepage = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki;
    license = "GPLv2";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}
