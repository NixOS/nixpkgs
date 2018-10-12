{ stdenv, fetchFromGitHub, meson, ninja, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "2.15";
  name = "libmpdclient-${version}";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "libmpdclient";
    rev    = "v${version}";
    sha256 = "18x6drzh867afwaakyfb8hcx37pnxxwvvpcs3n2fimnfa6vxgwaa";
  };

  nativeBuildInputs = [ meson ninja ]
  ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  meta = with stdenv.lib; {
    description = "Client library for MPD (music player daemon)";
    homepage = https://www.musicpd.org/libs/libmpdclient/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ehmry ];
  };
}
