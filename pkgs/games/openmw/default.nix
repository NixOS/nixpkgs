{ stdenv, fetchFromGitHub, qt4, openscenegraph, mygui, bullet, ffmpeg, boost, cmake, SDL2, unshield, openal
, libXt, pkgconfig }:

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
    rev = "ef85b1393aeaec905f6310abca29b4e0f42db901";
    sha256 = "0rxkw0bzag7qffifg28dyyga47aaaf5ziiccpv7p8yax1wglvymh";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake boost ffmpeg qt4 bullet mygui openscenegraph_ SDL2 unshield openal libXt ];

  meta = with stdenv.lib; {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = http://openmw.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
