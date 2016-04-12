{ stdenv, fetchFromGitHub, qt4, openscenegraph, mygui, bullet, ffmpeg, boost, cmake, SDL2, unshield, openal, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.38.0";
  name = "openmw-${version}";

  src = fetchFromGitHub {
    owner = "OpenMW";
    repo = "openmw";
    rev = name;
    sha256 = "1ssz1pa59a34v5vxiccqyvij5s38kl662p7xbc59y90y668f78y6";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake boost ffmpeg qt4 bullet mygui openscenegraph SDL2 unshield openal pkgconfig ];

  meta = {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = "http://openmw.org";
    license = stdenv.lib.licenses.gpl3;
  };
}
