{ stdenv, fetchFromGitHub, alsaLib, cmake, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "apulse-${version}";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "apulse";
    rev = "v${version}";
    sha256 = "018gaxn647wz1vjbr49hfrch9svnv0d1nzijc8ckb4fsr8vv95a1";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ alsaLib glib ];

  meta = with stdenv.lib; {
    description = "PulseAudio emulation for ALSA";
    homepage = https://github.com/i-rinat/apulse;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
