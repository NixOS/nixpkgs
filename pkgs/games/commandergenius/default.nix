{ lib, stdenv, fetchFromGitHub, SDL2, SDL2_image, pkgconfig
, libvorbis, libogg, mesa, boost, curl, zlib, cmake }:


stdenv.mkDerivation rec {
  name = "commandergenius-${version}";
  version = "194beta";

  src = fetchFromGitHub {
    owner = "gerstrong";
    repo = "Commander-Genius";
    rev = "v${version}";
    sha256 = "0qxqzlmadxklrhxilbqj7y94fmbv0byj6vgpl59lb77lgs4y4x47";
  };

  buildInputs = [ SDL2 SDL2_image pkgconfig libvorbis libogg mesa boost curl zlib cmake ];

  patchPhase = ''
    cat >> lib/GsKit/CMakeLists.txt <<EOF
    execute_process(COMMAND sdl2-config --cflags
      OUTPUT_VARIABLE CFLAGS)
    string(REGEX REPLACE "^-I" "" CFLAGS2 \''${CFLAGS})
    string(REGEX REPLACE " .*" "" SDLINC \''${CFLAGS2})
    INCLUDE_DIRECTORIES(\''${SDLINC})
    EOF
  '';

  configurePhase = ''
    cmake -DUSE_SDL2=yes -DBUILD_TARGET=LINUX -DCMAKE_INSTALL_PREFIX:PATH=$out -DCPACK_PACKAGE_INSTALL_DIRECTORY=$out
    sed -i 's_/usr/share_$out_g' cmake_install.cmake
    sed -i 's_/usr/share_$out_g' src/cmake_install.cmake
  '';

  installTargets = [ ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/CGeniusExe $out/bin
  '';

  meta = {
    description = "Modern Interpreter for the Commander Keen Games";
    longdescription = ''
      Commander Genius is an open-source clone of
      Commander Keen which allows you to play
      the games, and some of the mods
      made for it. All of the original data files
      are required to do so
    '';
    homepage = "https://github.com/gerstrong/Commander-Genius";
    maintainers = with stdenv.lib.maintainers; [ hce ]; 
    license = stdenv.lib.licenses.gpl2;
  };
}
