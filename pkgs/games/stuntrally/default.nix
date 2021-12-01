{ lib
, fetchFromGitHub
, stdenv
, cmake
, boost
, ogre
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
}:

stdenv.mkDerivation rec {
  pname = "stunt-rally";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "stuntrally";
    repo = "stuntrally";
    rev = version;
    hash = "sha256-1+Cc9I6TTa3b++/7Z2V+vAXcmFb2+wX7TnXEH6CRDWU=";
  };
  tracks = fetchFromGitHub {
    owner = "stuntrally";
    repo = "tracks";
    rev = version;
    hash = "sha256-FbZc87j/9cp4LxNaEO2wNTvwk1Aq/IWcKD3rTGkzqj0=";
  };

  # include/OGRE/OgreException.h:265:126: error: invalid conversion from
  # 'int' to 'Ogre::Exception::ExceptionCodes' [-fpermissive]
  NIX_CFLAGS_COMPILE = "-fpermissive";

  preConfigure = ''
    ln -s ${tracks} data/tracks
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    boost
    ogre
    mygui
    ois
    SDL2
    libvorbis
    makeWrapper
    enet
    libXcursor
    bullet
    openal
  ];

  meta = with lib; {
    description = "Stunt Rally game with Track Editor, based on VDrift and OGRE";
    homepage = "http://stuntrally.tuxfamily.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
