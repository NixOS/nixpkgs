{ fetchgit, stdenv, cmake, boost, ogre, mygui, ois, SDL2, libvorbis, pkgconfig
, makeWrapper, enet, libXcursor }:

stdenv.mkDerivation rec {
  name = "stunt-rally-2.4";

  src = fetchgit {
    url = git://github.com/stuntrally/stuntrally.git;
    rev = "refs/tags/2.4";
    sha256 = "0zyzkac11dv9c1rxknydkisg2iw1rmi72psidl7jmq8v3rrqxk4r";
  };

  tracks = fetchgit {
    url = git://github.com/stuntrally/tracks.git;
    rev = "refs/tags/2.4";
    sha256 = "1j237dbhd1ik5mj8whbvlff5da9vzzgiskcj5nzfpw1vb1jpdjvd";
  };

  preConfigure = ''
    cp -R ${tracks} data/tracks
    chmod u+rwX -R data
  '';

  buildInputs = [ cmake boost ogre mygui ois SDL2 libvorbis pkgconfig 
    makeWrapper enet
    libXcursor
  ];

  # I think they suppose cmake should give them OGRE_PLUGIN_DIR defined, but
  # the cmake code I saw is not ready for that. Therefore, we use the env var.
  postInstall = ''
    wrapProgram $out/bin/stuntrally --set OGRE_PLUGIN_DIR ${ogre}/lib/OGRE
    wrapProgram $out/bin/sr-editor --set OGRE_PLUGIN_DIR ${ogre}/lib/OGRE
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Stunt Rally game with Track Editor, based on VDrift and OGRE";
    homepage = http://code.google.com/p/vdrift-ogre/;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
