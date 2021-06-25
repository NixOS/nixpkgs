{ lib, stdenv, cmake, pkg-config, git, curl, SDL2, xercesc, openal, lua, libvlc
, libjpeg, wxGTK, cppunit, ftgl, glew, libogg, libvorbis, buildEnv, libpng
, fontconfig, freetype, xorg, makeWrapper, bash, which, gnome, libGLU, glib
, fetchFromGitHub
}:
let
  version = "3.13.0";
  lib-env = buildEnv {
    name = "megaglest-lib-env";
    paths = [ SDL2 xorg.libSM xorg.libICE xorg.libX11 xorg.libXext
      xercesc openal libvorbis lua libjpeg libpng curl fontconfig ftgl freetype
      stdenv.cc.cc glew libGLU wxGTK ];
  };
  path-env = buildEnv {
    name = "megaglest-path-env";
    paths = [ bash which gnome.zenity ];
  };
in
stdenv.mkDerivation {
  pname = "megaglest";
  inherit version;

  src = fetchFromGitHub {
    owner = "MegaGlest";
    repo = "megaglest-source";
    rev = version;
    fetchSubmodules = true;
    sha256 = "0fb58a706nic14ss89zrigphvdiwy5s9dwvhscvvgrfvjpahpcws";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ git curl SDL2 xercesc openal lua libpng libjpeg libvlc wxGTK
    glib cppunit fontconfig freetype ftgl glew libogg libvorbis makeWrapper libGLU ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DBUILD_MEGAGLEST=On"
    "-DBUILD_MEGAGLEST_MAP_EDITOR=On"
    "-DBUILD_MEGAGLEST_MODEL_IMPORT_EXPORT_TOOLS=On"
    "-DBUILD_MEGAGLEST_MODEL_VIEWER=On"
  ];

  postInstall =  ''
    for i in $out/bin/*; do
      wrapProgram $i \
        --prefix LD_LIBRARY_PATH ":" "${lib-env}/lib" \
        --prefix PATH ":" "${path-env}/bin"
    done
  '';

  meta = with lib; {
    description = "An entertaining free (freeware and free software) and open source cross-platform 3D real-time strategy (RTS) game";
    license = licenses.gpl3;
    homepage = "http://megaglest.org/";
    maintainers = [ maintainers.matejc ];
    platforms = platforms.linux;
  };
}
