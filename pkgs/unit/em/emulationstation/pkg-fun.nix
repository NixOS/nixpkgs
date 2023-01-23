{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, curl, boost169, eigen
, freeimage, freetype, libGLU, libGL, SDL2, alsa-lib, libarchive
, fetchpatch }:

stdenv.mkDerivation {
  pname = "emulationstation";
  version = "2.0.1a";

  src = fetchFromGitHub {
    owner = "Aloshi";
    repo = "EmulationStation";
    rev = "646bede3d9ec0acf0ae378415edac136774a66c5";
    sha256 = "0cm0sq2wri2l9cvab1l0g02za59q7klj0h3p028vr96n6njj4w9v";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Aloshi/EmulationStation/commit/49ccd8fc7a7b1dfd974fc57eb13317c42842f22c.patch";
      sha256 = "1v5d81l7bav0k5z4vybrc3rjcysph6lkm5pcfr6m42wlz7jmjw0p";
    })
  ];

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ alsa-lib boost169 curl eigen freeimage freetype libarchive libGLU libGL SDL2 ];

  installPhase = ''
    install -D ../emulationstation $out/bin/emulationstation
  '';

  meta = {
    description = "A flexible emulator front-end supporting keyboardless navigation and custom system themes";
    homepage = "https://emulationstation.org";
    maintainers = [ lib.maintainers.edwtjo ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
