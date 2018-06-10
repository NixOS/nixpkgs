{ stdenv, fetchFromGitHub, meson, ninja, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "2.14";
  name = "libmpdclient-${version}";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "libmpdclient";
    rev    = "v${version}";
    sha256 = "15vn9m4qcsccff5rg7jkzy5503skz6bmqqk6qc2smgvjgwn533sm";
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
