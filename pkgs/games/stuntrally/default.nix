{ fetchurl, stdenv, cmake, boost, ogre, mygui, ois, SDL2, libvorbis, pkgconfig
, makeWrapper, enet, libXcursor, bullet, openal }:

stdenv.mkDerivation rec {
  pname = "stunt-rally";
  version = "2.6.1";

  src = fetchurl {
    url = "https://github.com/stuntrally/stuntrally/archive/${version}.tar.gz";
    sha256 = "1zxq3x2g9pzafa2awx9jzqd33z6gnqj231cs07paxzrm89y51w4v";
  };

  tracks = fetchurl {
    url = "https://github.com/stuntrally/tracks/archive/${version}.tar.gz";
    sha256 = "0x6lgpa4c2grl0vrhqrcs7jcysa3mmvpdl1v5xa0dsf6vkvfr0zs";
  };

  # include/OGRE/OgreException.h:265:126: error: invalid conversion from
  # 'int' to 'Ogre::Exception::ExceptionCodes' [-fpermissive]
  NIX_CFLAGS_COMPILE="-fpermissive";

  preConfigure = ''
    pushd data
    tar xf ${tracks}
    mv tracks-${version} tracks
    popd
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake boost ogre mygui ois SDL2 libvorbis 
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
