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
      rev = "c0adcc0b43f37931ccb70e3e2b4227c4a86cfaaf";
      sha256 = "12nrpayms0jl2knkv4kax93si1510hjyl1g3i1b73ydnzhvr3x02";
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
    maintainers = with maintainers; [ abbradar ];
  };
}
