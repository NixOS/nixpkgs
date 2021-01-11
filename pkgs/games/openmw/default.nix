{ lib, stdenv, fetchFromGitHub, qtbase, openscenegraph, mygui, bullet, ffmpeg_3
, boost, cmake, SDL2, unshield, openal, libXt, pkg-config }:

let
  openscenegraph_ = openscenegraph.overrideDerivation (self: {
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "osg";
      rev = "1556cd7966ebc1c80b6626988d2b25fb43a744cf";
      sha256 = "0d74hijzmj82nx3jkv5qmr3pkgvplra0b8fbjx1y3vmzxamb0axd";
    };
  });
in

stdenv.mkDerivation rec {
  version = "0.46.0";
  pname = "openmw";

  src = fetchFromGitHub {
    owner = "OpenMW";
    repo = "openmw";
    rev = "${pname}-${version}";
    sha256 = "0rm32zsmxvr6b0jjihfj543skhicbw5kg6shjx312clhlm035w2x";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost ffmpeg_3 bullet mygui openscenegraph_ SDL2 unshield openal libXt qtbase ];

  cmakeFlags = [
    "-DDESIRED_QT_VERSION:INT=5"
  ];

  meta = with lib; {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = "http://openmw.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
