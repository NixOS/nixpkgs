{ stdenv, fetchFromGitHub, autoreconfHook, doxygen }:

stdenv.mkDerivation rec {
  version = "${passthru.majorVersion}.${passthru.minorVersion}";
  name = "libmpdclient-${version}";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "libmpdclient";
    rev    = "v${version}";
    sha256 = "06rv2j8rw9v9l4nwpvbh28nad8bbg368hzd8s58znbr5pgb8dihd";
  };

  nativeBuildInputs = [ autoreconfHook doxygen ];

  enableParallelBuilding = true;

  passthru = {
    majorVersion = "2";
    minorVersion = "11";
  };

  meta = with stdenv.lib; {
    description = "Client library for MPD (music player daemon)";
    homepage = http://www.musicpd.org/libs/libmpdclient/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mornfall ehmry ];
  };
}
