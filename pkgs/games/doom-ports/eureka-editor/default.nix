{ lib, stdenv, fetchzip, fltk, zlib, xdg-utils, xorg, libjpeg, libGLU }:

stdenv.mkDerivation rec {
  pname = "eureka-editor";
  version = "1.27b";

  src = fetchzip {
    url = "mirror://sourceforge/eureka-editor/Eureka/${lib.versions.majorMinor version}/eureka-${version}-source.tar.gz";
    sha256 = "075w7xxsgbgh6dhndc1pfxb2h1s5fhsw28yl1c025gmx9bb4v3bf";
  };

  buildInputs = [ fltk zlib xdg-utils libjpeg xorg.libXinerama libGLU ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace src/main.cc --replace /usr/local $out
    substituteInPlace Makefile    --replace /usr/local $out
  '';

  preInstall = ''
    mkdir -p $out/bin $out/share/applications $out/share/icons $out/man/man6
    cp misc/eureka.desktop $out/share/applications
    cp misc/eureka.ico $out/share/icons
    cp misc/eureka.6 $out/man/man6
  '';

  meta = with lib; {
    homepage = "https://eureka-editor.sourceforge.net";
    description = "A map editor for the classic DOOM games, and a few related games such as Heretic and Hexen";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
    maintainers = with maintainers; [ neonfuz ];
  };
}
