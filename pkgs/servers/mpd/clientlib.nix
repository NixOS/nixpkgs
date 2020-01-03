{ stdenv, fetchFromGitHub, meson, ninja, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "2.17";
  pname = "libmpdclient";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "libmpdclient";
    rev    = "v${version}";
    sha256 = "0458zq12ph1pbm9mcbdj8mm31iq3yzzc1aq9fhfwz341zwpwcp21";
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
