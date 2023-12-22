{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "libmpdclient";
  version = "2.21";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-U9K/4uivK5lx/7mG71umKGzP/KWgnexooF7weGu4B78=";
  };

  nativeBuildInputs = [ meson ninja ]
  ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  meta = with lib; {
    description = "Client library for MPD (music player daemon)";
    homepage = "https://www.musicpd.org/libs/libmpdclient/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ehmry AndersonTorres ];
    platforms = platforms.unix;
  };
}
