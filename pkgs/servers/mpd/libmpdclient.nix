{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "libmpdclient";
  version = "2.19";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "01agvjscdxagw6jcfx0wg81c4b6p8rh0hp3slycmjs2b835kvmq2";
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
