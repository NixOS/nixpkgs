{ stdenv, fetchgit, cmake, git, curl, SDL, xercesc, openal, lua
, libjpeg, wxGTK, cppunit, ftgl, glew, libogg, libvorbis, buildEnv, libpng
, fontconfig, freetype, xlibs, makeWrapper, bash, which, gnome3, mesa_glu
, mesa_drivers }:
let
  version = "3.9.2";
  lib-env = buildEnv {
    name = "megaglest-lib-env";
    paths = [ SDL xlibs.libSM xlibs.libICE xlibs.libX11 xlibs.libXext
      xercesc openal libvorbis lua libjpeg libpng curl fontconfig ftgl freetype
      stdenv.cc.gcc glew mesa_glu mesa_drivers wxGTK ];
  };
  path-env = buildEnv {
    name = "megaglest-path-env";
    paths = [ bash which gnome3.zenity ];
  };
in
stdenv.mkDerivation {
  name = "megaglest-${version}";

  src = fetchgit {
    url = "git://github.com/MegaGlest/megaglest-source";
    rev = "refs/tags/${version}";
    sha256 = "0jdgcpsv16vdxkwym7pw764pggifn4g98f3dzg615xl9h4wkymm0";
  };

  buildInputs = [ cmake git curl SDL xercesc openal lua libjpeg wxGTK
    cppunit ftgl glew libogg libvorbis makeWrapper mesa_glu mesa_drivers ];

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
