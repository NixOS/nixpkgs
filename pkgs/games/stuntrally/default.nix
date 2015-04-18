{ fetchgit, stdenv, cmake, boost, ogre, mygui, ois, SDL2, libvorbis, pkgconfig
, makeWrapper, enet, libXcursor }:

stdenv.mkDerivation rec {
  name = "stunt-rally-${version}";
  version = "2.5";

  src = fetchgit {
    url = git://github.com/stuntrally/stuntrally.git;
    rev = "refs/tags/${version}";
    sha256 = "1lsh7z7sjfwpdybg6vbwqx1zxsgbfp2n60n7xl33v225p32qh1qf";
  };

  tracks = fetchgit {
    url = git://github.com/stuntrally/tracks.git;
    rev = "refs/tags/${version}";
    sha256 = "1614j6q1d2f69l58kkqndndvf6svcghhw8pzc2s1plf6k87h67mg";
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
  };
}
