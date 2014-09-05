{ stdenv, fetchFromGitHub, pkgconfig, cmake, curl, boost, eigen
, freeimage, freetype, mesa, SDL2, alsaLib, libarchive }:

stdenv.mkDerivation rec {
  name = "emulationstation-${version}";
  version = "2.0.0-rc1";

  src = fetchFromGitHub {
    owner = "Aloshi";
    repo = "EmulationStation";
    rev = "8739519e1591819cab85e1d2056804d20c197dac";
    sha256 = "1psq5cqyq2yy1lqxrcj7pfp8szfmzhamxf3111l97w2h2zzcgvq9";
  };

  buildInputs = [ pkgconfig cmake alsaLib boost curl eigen freeimage freetype libarchive mesa SDL2 ];

  buildPhase = "cmake . && make";
  installPhase = ''
    install -D ../emulationstation $out/bin/emulationstation
  '';

  meta = {
    description = "A flexible emulator front-end supporting keyboardless navigation and custom system themes";
    homepage = "http://emulationstation.org";
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    license = stdenv.lib.licenses.mit;
  };
}