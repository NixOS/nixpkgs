{ fetchurl, stdenv, cmake, boost, ogre, mygui, ois, SDL2, libvorbis, pkgconfig
, makeWrapper, enet, libXcursor, bullet, openal }:

stdenv.mkDerivation rec {
  name = "stunt-rally-${version}";
  version = "2.6";

  src = fetchurl {
    url = "https://github.com/stuntrally/stuntrally/archive/${version}.tar.gz";
    sha256 = "1jmsxd2isq9q5paz43c3xw11vr5md1ym8h34b768vxr6gp90khwc";
  };

  tracks = fetchurl {
    url = "https://github.com/stuntrally/tracks/archive/${version}.tar.gz";
    sha256 = "0yv88l9s03kp1xkkwnigh0jj593vi3r7vgyg0jn7i8d22q2p1kjb";
  };

  # include/OGRE/OgreException.h:265:126: error: invalid conversion from
  # 'int' to 'Ogre::Exception::ExceptionCodes' [-fpermissive]
  NIX_CFLAGS_COMPILE="-fpermissive";

  preConfigure = ''
    pushd data
    tar xf ${tracks}
    mv tracks-2.6 tracks
    popd
  '';

  buildInputs = [ cmake boost ogre mygui ois SDL2 libvorbis pkgconfig 
    makeWrapper enet libXcursor bullet openal
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Stunt Rally game with Track Editor, based on VDrift and OGRE";
    homepage = http://stuntrally.tuxfamily.org/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
