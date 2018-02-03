{ stdenv, fetchFromGitHub, meson, ninja, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "2.13";
  name = "libmpdclient-${version}";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "libmpdclient";
    rev    = "v${version}";
    sha256 = "1g1n6rk8kn87mbjqxxj0vi7haj8xx21xmqlzbrx2fvyp5357zvsq";
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
