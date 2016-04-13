{ fetchgit, stdenv, cmake, boost, ogre, mygui, ois, SDL2, libvorbis, pkgconfig
, makeWrapper, enet, libXcursor }:

stdenv.mkDerivation rec {
  name = "stunt-rally-${version}";
  version = "2.6";

  src = fetchgit {
    url = git://github.com/stuntrally/stuntrally.git;
    rev = "refs/tags/${version}";
    sha256 = "0rrfmldl6m7igni1n4rv2i0s2q5j1ik8dh05ydkaqrpcky96bdr8";
  };

  tracks = fetchgit {
    url = git://github.com/stuntrally/tracks.git;
    rev = "refs/tags/${version}";
    sha256 = "186qqyr1nrabfzsgy7b4sjgm38mgd875f4c7qwkm8k2bl7zjkrm2";
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
    platforms = platforms.linux;
    # Build failure
    broken = true;
  };
}
