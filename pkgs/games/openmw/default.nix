{ stdenv, fetchFromGitHub, qt5, qt4, openscenegraph, mygui, bullet, ffmpeg
, boost, cmake, SDL2, unshield, openal, libXt, pkgconfig
, useQt5 ? true }:

let
  openscenegraph_ = openscenegraph.overrideDerivation (self: {
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "osg";
      rev = "2b4c8e37268e595b82da4b9aadd5507852569b87";
      sha256 = "0admnllxic6dcpic0h100927yw766ab55dix002vvdx36i6994jb";
    };
  });
in stdenv.mkDerivation rec {
  version = "0.44.0";
  name = "openmw-${version}";

  src = fetchFromGitHub {
    owner = "OpenMW";
    repo = "openmw";
    rev = name;
    sha256 = "0rxkw0bzag7qffifg28dyyga47aaaf5ziiccpv7p8yax1wglvymh";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake boost ffmpeg bullet mygui openscenegraph_ SDL2 unshield openal libXt ]
  ++ [ (if useQt5 then qt5.qtbase else qt4) ];
  cmakeFlags = [
    "-DDESIRED_QT_VERSION:INT=${if useQt5 then "5" else "4"}"
  ];

  meta = with stdenv.lib; {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = http://openmw.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
