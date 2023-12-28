{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "libmpdclient";
  version = "2.22";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-KF8IR9YV6b9ro+L9m6nHs1IggakEZddfcBKm/oKCVZY=";
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
