{ stdenv, fetchFromGitHub, cmake, pkgconfig, git, curl, SDL, xercesc, openal, lua, vlc
, libjpeg, wxGTK, cppunit, ftgl, glew, libogg, libvorbis, buildEnv, libpng
, fontconfig, freetype, xorg, makeWrapper, bash, which, gnome3, mesa_glu, glib
}:
let
  version = "3.9.2";
  lib-env = buildEnv {
    name = "megaglest-lib-env";
    paths = [ SDL xorg.libSM xorg.libICE xorg.libX11 xorg.libXext
      xercesc openal libvorbis lua libjpeg libpng curl fontconfig ftgl freetype
      stdenv.cc.cc glew mesa_glu wxGTK ];
  };
  path-env = buildEnv {
    name = "megaglest-path-env";
    paths = [ bash which gnome3.zenity ];
  };
in
stdenv.mkDerivation {
  name = "megaglest-${version}";

  src = fetchFromGitHub {
    owner = "MegaGlest";
    repo = "megaglest-source";
    rev = "refs/tags/${version}";
    sha256 = "0h1866c0r3569v6z9zvmkjrb76vkks9na2ph6mi7apm3blc44yq2";
  };

  buildInputs = [ cmake pkgconfig git curl SDL xercesc openal lua libpng libjpeg vlc wxGTK
    glib cppunit fontconfig freetype ftgl glew libogg libvorbis makeWrapper mesa_glu ];

  configurePhase = ''
    cmake -DCMAKE_INSTALL_PREFIX=$out -DBUILD_MEGAGLEST_TESTS=ON
  '';

  postInstall =  ''
    for i in $out/bin/*; do
      wrapProgram $i \
        --prefix LD_LIBRARY_PATH ":" "${lib-env}/lib" \
        --prefix PATH ":" "${path-env}/bin"
    done
  '';

  meta = {
    description = "MegaGlest is an entertaining free (freeware and free software) and open source cross-platform 3D real-time strategy (RTS) game";
    license = stdenv.lib.licenses.gpl3;
    homepage = "http://megaglest.org/";
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
