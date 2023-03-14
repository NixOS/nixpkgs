{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "libmpdclient";
  version = "2.20";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-qEgdwG7ygVblIa3uRf1tddxHg7T1yvY17nbhZ7NRNvg=";
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
