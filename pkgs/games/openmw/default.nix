{ stdenv, fetchFromGitHub, qt4, openscenegraph, mygui, bullet, ffmpeg, boost, cmake, SDL2, unshield, openal
, giflib, pkgconfig }:

let
  openscenegraph_ = openscenegraph.override {
    inherit ffmpeg giflib;
    withApps = false;
  };
  openscenegraph__ = openscenegraph_.overrideDerivation (self: {
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "osg";
      rev = "a72f43de6e1e4a8191643acb26c3e7138f833798";
      sha256 = "04x2pjfrdz1kaj4i34zpzrmkk018jnr84rb6z646cz5fin3dapyh";
    };
  });
in stdenv.mkDerivation rec {
  version = "0.39.0";
  name = "openmw-${version}";

  src = fetchFromGitHub {
    owner = "OpenMW";
    repo = "openmw";
    rev = name;
    sha256 = "0haz8p0hwzgpj634q34if6x57rkc3zsndry5pz4a25m23sn1i72y";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake boost ffmpeg qt4 bullet mygui openscenegraph__ SDL2 unshield openal pkgconfig ];

  meta = with stdenv.lib; {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = "http://openmw.org";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
