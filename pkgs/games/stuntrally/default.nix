{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  boost,
  ogre_13,
  mygui,
  ois,
  SDL2,
  libX11,
  libvorbis,
  pkg-config,
  makeWrapper,
  enet,
  libXcursor,
  bullet,
  openal,
  tinyxml,
  tinyxml-2,
}:

let
  stuntrally_ogre = ogre_13.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [
      "-DOGRE_NODELESS_POSITIONING=ON"
      "-DOGRE_RESOURCEMANAGER_STRICT=0"
    ];
  });
  stuntrally_mygui = mygui.override {
    withOgre = true;
    ogre = stuntrally_ogre;
  };
in

stdenv.mkDerivation rec {
  pname = "stuntrally";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "stuntrally";
    repo = "stuntrally";
    rev = version;
    hash = "sha256-0Eh9ilIHSh/Uz8TuPnXxLQfy7KF7qqNXUgBXQUCz9ys=";
  };
  tracks = fetchFromGitHub {
    owner = "stuntrally";
    repo = "tracks";
    rev = version;
    hash = "sha256-fglm1FetFGHM/qGTtpxDb8+k2iAREn5DQR5GPujuLms=";
  };

  postPatch = ''
    substituteInPlace config/*-default.cfg \
      --replace "screenshot_png = off" "screenshot_png = on"
    substituteInPlace source/*/BaseApp_Create.cpp \
      --replace "Codec_FreeImage" "Codec_STBI"
  '';

  preConfigure = ''
    rmdir data/tracks
    ln -s ${tracks}/ data/tracks
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    boost
    stuntrally_ogre
    stuntrally_mygui
    ois
    SDL2
    libX11
    libvorbis
    enet
    libXcursor
    bullet
    openal
    tinyxml
    tinyxml-2
  ];

  meta = with lib; {
    description = "Stunt Rally game with Track Editor, based on VDrift and OGRE";
    homepage = "http://stuntrally.tuxfamily.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
