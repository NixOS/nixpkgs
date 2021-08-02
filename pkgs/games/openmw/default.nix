{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, openscenegraph
, mygui
, bullet
, ffmpeg
, boost
, SDL2
, unshield
, openal
, libXt
}:

let
  openscenegraph_ = openscenegraph.overrideDerivation (self: {
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "osg";
      # commit does not exist on any branch on the target repository
      rev = "1556cd7966ebc1c80b6626988d2b25fb43a744cf";
      sha256 = "0d74hijzmj82nx3jkv5qmr3pkgvplra0b8fbjx1y3vmzxamb0axd";
    };
  });

in
mkDerivation rec {
  version = "0.46.0";
  pname = "openmw";

  src = fetchFromGitHub {
    owner = "OpenMW";
    repo = "openmw";
    rev = "${pname}-${version}";
    sha256 = "0rm32zsmxvr6b0jjihfj543skhicbw5kg6shjx312clhlm035w2x";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  buildInputs = [
    SDL2
    boost
    bullet
    ffmpeg
    libXt
    mygui
    openal
    openscenegraph_
    unshield
  ];

  cmakeFlags = [
    "-DDESIRED_QT_VERSION:INT=5"
    # as of 0.46, openmw is broken with GLVND
    "-DOpenGL_GL_PREFERENCE=LEGACY"
  ];

  meta = with lib; {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = "http://openmw.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
