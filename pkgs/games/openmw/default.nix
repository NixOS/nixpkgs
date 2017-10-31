{ stdenv, fetchFromGitHub, qt4, openscenegraph, mygui, bullet, ffmpeg, boost, cmake, SDL2, unshield, openal
, giflib, libXt, pkgconfig }:

let
  openscenegraph_ = openscenegraph.overrideDerivation (self: {
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "osg";
      rev = "35f1a459a4ab6da9d70427e6539bdf4faae4cc91";
      sha256 = "1s3a9dpbcc6v8d05pqin4xfv36i2031xpdja1vl8x11cw05fln91";
    };
  });
in stdenv.mkDerivation rec {
  version = "0.42.0";
  name = "openmw-${version}";

  src = fetchFromGitHub {
    owner = "OpenMW";
    repo = "openmw";
    rev = name;
    sha256 = "0lj8v81hk807dy0wcdhfp0iyn4l5yag53hx1a6xm44gh2dpyil43";
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
