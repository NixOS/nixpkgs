{ fetchgit, stdenv, cmake, boost, ogre, mygui, ois, SDL, libvorbis, pkgconfig
, makeWrapper, enet, libXcursor }:

stdenv.mkDerivation rec {
  name = "stunt-rally-1.8";

  src = fetchgit {
    url = git://github.com/stuntrally/stuntrally.git;
    rev = "refs/tags/1.8";
    sha256 = "0p8p83xx8q33kymsqnmxqca4jdfyg9rwrsac790z56gdbc7gnahm";
  };

  tracks = fetchgit {
    url = git://github.com/stuntrally/tracks.git;
    rev = "refs/tags/1.8";
    sha256 = "1gcrs21nn0v3hvhrw8dc0wh1knn5qh66cjx7a1igiciiadmi2s3l";
  };

  patchPhase = ''
    sed -i 's/materials/materials material_templates/' data/CMakeLists.txt
  '';

  preConfigure = ''
    mkdir data/tracks
    cp -R $tracks/* data/tracks
  '';

  buildInputs = [ cmake boost ogre mygui ois SDL libvorbis pkgconfig makeWrapper enet
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
    license = "GPLv3+";
  };
}
