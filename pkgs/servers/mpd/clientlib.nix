{ stdenv, fetchFromGitHub, meson, ninja, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "2.19";
  pname = "libmpdclient";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "libmpdclient";
    rev    = "v${version}";
    sha256 = "01agvjscdxagw6jcfx0wg81c4b6p8rh0hp3slycmjs2b835kvmq2";
  };

  nativeBuildInputs = [ meson ninja ]
  ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  meta = with stdenv.lib; {
    description = "Client library for MPD (music player daemon)";
    homepage = "https://www.musicpd.org/libs/libmpdclient/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ehmry ];
  };
}
