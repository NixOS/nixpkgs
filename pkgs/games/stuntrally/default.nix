{ lib
, fetchFromGitHub
, stdenv
, cmake
, boost
<<<<<<< HEAD
, ogre_13
=======
, ogre
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mygui
, ois
, SDL2
, libvorbis
, pkg-config
, makeWrapper
, enet
, libXcursor
, bullet
, openal
, tinyxml
, tinyxml-2
}:

let
<<<<<<< HEAD
  stuntrally_ogre = ogre_13.overrideAttrs (old: {
=======
  stuntrally_ogre = ogre.overrideAttrs (old: {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cmakeFlags = old.cmakeFlags ++ [
      "-DOGRE_NODELESS_POSITIONING=ON"
      "-DOGRE_RESOURCEMANAGER_STRICT=0"
    ];
  });
  stuntrally_mygui = mygui.override {
    withOgre = true;
<<<<<<< HEAD
    ogre = stuntrally_ogre;
=======
    inherit ogre;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  preConfigure = ''
    rmdir data/tracks
    ln -s ${tracks}/ data/tracks
  '';

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];
  buildInputs = [
    boost
    stuntrally_ogre
    stuntrally_mygui
    ois
    SDL2
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
