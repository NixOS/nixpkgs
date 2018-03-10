{ stdenv, fetchFromGitHub, pkgconfig, cmake, curl, boost, eigen
, freeimage, freetype, libGLU_combined, SDL2, alsaLib, libarchive }:

stdenv.mkDerivation rec {
  name = "emulationstation-${version}";
  version = "2.0.1a";

  src = fetchFromGitHub {
    owner = "Aloshi";
    repo = "EmulationStation";
    rev = "646bede3d9ec0acf0ae378415edac136774a66c5";
    sha256 = "0cm0sq2wri2l9cvab1l0g02za59q7klj0h3p028vr96n6njj4w9v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake alsaLib boost curl eigen freeimage freetype libarchive libGLU_combined SDL2 ];

  buildPhase = "cmake . && make";
  installPhase = ''
    install -D ../emulationstation $out/bin/emulationstation
  '';

  meta = {
    description = "A flexible emulator front-end supporting keyboardless navigation and custom system themes";
    homepage = http://emulationstation.org;
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
