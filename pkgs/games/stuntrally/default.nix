{ fetchurl, stdenv, cmake, boost, ogre, myguiSvn, ois, SDL, libvorbis, pkgconfig
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "stunt-rally-1.4";

  src = fetchurl {
    url = mirror://sourceforge/stuntrally/StuntRally-1.4-sources.tar.bz2;
    sha256 = "1am5af4l1qliyrq1183sqvwzqwcjx0v6gkzsxhfmk6ygp7yhw7kq";
  };

  buildInputs = [ cmake boost ogre myguiSvn ois SDL libvorbis pkgconfig makeWrapper ];

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
