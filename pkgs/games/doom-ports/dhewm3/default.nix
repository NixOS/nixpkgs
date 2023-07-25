{ lib, stdenv, fetchFromGitHub, cmake, SDL2, libGLU, libGL, zlib, libjpeg, libogg, libvorbis
, openal, curl, copyDesktopItems, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "dhewm3";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "dhewm";
    repo = "dhewm3";
    rev = version;
    sha256 = "sha256-3ONOP/pRp04rxehXxgCCan1fPCqAs2bVDU/R4HPN1xQ=";
  };

  # Add libGLU libGL linking
  patchPhase = ''
    sed -i 's/\<idlib\()\?\)$/idlib GL\1/' neo/CMakeLists.txt
  '';

  preConfigure = ''
    cd "$(ls -d dhewm3-*.src)"/neo
  '';

  nativeBuildInputs = [ cmake copyDesktopItems ];
  buildInputs = [ SDL2 libGLU libGL zlib libjpeg libogg libvorbis openal curl ];

  desktopItems = [
    (makeDesktopItem {
      name = "dhewm3";
      exec = "dhewm3";
      desktopName = "Doom 3";
      categories = [ "Game" ];
    })
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://github.com/dhewm/dhewm3";
    description = "Doom 3 port to SDL";
    license = lib.licenses.gpl3;
    maintainers = with maintainers; [ MP2E ];
    platforms = with platforms; linux;
  };
}
