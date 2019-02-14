{ stdenv, fetchFromGitHub, cmake, doxygen, pkgconfig
, qtbase, openscenegraph, mygui, bullet, ffmpeg, boost, SDL2, unshield, openal
, giflib, libXt }:

let
  openscenegraph_ = openscenegraph.overrideDerivation (self: {
    name = "openmw-openscenegraph";

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

  nativeBuildInputs = [ cmake doxygen pkgconfig ];

  buildInputs = [
    qtbase
    boost bullet ffmpeg libXt mygui openal openscenegraph_ SDL2 unshield
  ];

  cmakeFlags = [
    "-DDESIRED_QT_VERSION=5"
  ];

  meta = with stdenv.lib; {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage    = "https://openmw.org";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.linux;
  };
}
