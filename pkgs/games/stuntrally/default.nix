{ fetchgit, stdenv, cmake, boost, ogre, mygui, ois, SDL2, libvorbis, pkgconfig
, makeWrapper, enet, libXcursor }:

stdenv.mkDerivation rec {
  name = "stunt-rally-${version}";
  version = "2.5";

  src = fetchgit {
    url = git://github.com/stuntrally/stuntrally.git;
    rev = "refs/tags/${version}";
    sha256 = "0zyzkac11dv9c1rxknydkisg2iw1rmi72psidl7jmq8v3rrqxk4r";
  };

  tracks = fetchgit {
    url = git://github.com/stuntrally/tracks.git;
    rev = "refs/tags/${version}";
    sha256 = "1j237dbhd1ik5mj8whbvlff5da9vzzgiskcj5nzfpw1vb1jpdjvd";
  };

  preConfigure = ''
    cp -R ${tracks} data/tracks
    chmod u+rwX -R data
  '';

  buildInputs = [ cmake boost ogre mygui ois SDL2 libvorbis pkgconfig 
    makeWrapper enet libXcursor
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Stunt Rally game with Track Editor, based on VDrift and OGRE";
    homepage = http://code.google.com/p/vdrift-ogre/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
  };
}
