{ stdenv, fetchurl, doxygen }:

stdenv.mkDerivation rec {
  version = "${passthru.majorVersion}.${passthru.minorVersion}";
  name = "libmpdclient-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/libmpdclient/2/${name}.tar.xz";
    sha256 = "1jlrfqxqq3gscwrppr2h0xqxd5abl1ypwpwpwnpxs6p9c2jppjbw";
  };

  buildInputs = [ doxygen ];

  passthru = {
    majorVersion = "2";
    minorVersion = "9";
  };

  meta = {
    description = "Client library for MPD (music player daemon)";
    homepage = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki;
    license = "GPLv2";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}
