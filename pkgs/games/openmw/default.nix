{ stdenv, mkDerivationWith, fetchFromGitHub, qtbase, openscenegraph, mygui, bullet, ffmpeg
, boost, cmake, SDL2, unshield, openal, libXt, pkgconfig }:

let
  openscenegraph_ = openscenegraph.overrideDerivation (self: {
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "osg";
      rev = "2b4c8e37268e595b82da4b9aadd5507852569b87";
      sha256 = "0admnllxic6dcpic0h100927yw766ab55dix002vvdx36i6994jb";
    };
  });
in mkDerivationWith stdenv.mkDerivation rec {
  version = "0.45.0";
  pname = "openmw";

  src = fetchFromGitHub {
    owner = "OpenMW";
    repo = "openmw";
    rev = "${pname}-${version}";
    sha256 = "1r87zrsnza2v9brksh809zzqj6zhk5xj15qs8iq11v1bscm2a2j4";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake boost ffmpeg bullet mygui openscenegraph_ SDL2 unshield openal libXt qtbase ];

  cmakeFlags = [
    "-DDESIRED_QT_VERSION:INT=5"
  ];

  meta = with stdenv.lib; {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = http://openmw.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
