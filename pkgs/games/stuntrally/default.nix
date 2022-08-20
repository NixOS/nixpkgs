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
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "stuntrally";
    repo = "stuntrally";
    rev = version;
    hash = "sha256-9I6hXsosqx+yYiEOEnPXQJHZkGtSU+JqThorwjemlc0=";
  };
  tracks = fetchFromGitHub {
    owner = "stuntrally";
    repo = "tracks";
    rev = version;
    hash = "sha256-eZJAvkKe3PrXDzxTa5WFBHfltB3jhQh8puzOFDO9lso=";
  };

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
