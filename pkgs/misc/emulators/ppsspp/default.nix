{ stdenv, fetchFromGitHub, cmake, pkgconfig, qtbase, qtmultimedia
, glew, libzip, snappy, zlib, withGamepads ? true, SDL2 }:

assert withGamepads -> (SDL2 != null);
with stdenv.lib;

stdenv.mkDerivation rec {
  name = "ppsspp-${version}";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = "ppsspp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0m4qkhx7q496sm7ibg2n7rm3npxzfr93iraxgndk0vhfk8vy8w75";
  };

  patchPhase = ''
    echo 'const char *PPSSPP_GIT_VERSION = "${src.rev}";' >> git-version.cpp
    substituteInPlace UI/NativeApp.cpp --replace /usr/share $out/share
  '';

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ qtbase qtmultimedia glew libzip snappy zlib ]
    ++ optionals withGamepads [ SDL2 SDL2.dev ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DUSING_QT_UI=ON" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/ppsspp
    mv PPSSPPQt $out/bin/ppsspp
    mv assets $out/share/ppsspp
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = https://www.ppsspp.org/;
    description = "A PSP emulator for Android, Windows, Mac and Linux, written in C++";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fuuzetsu AndersonTorres ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.cygwin;
  };
}
