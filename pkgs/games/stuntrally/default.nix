{ fetchurl, stdenv, cmake, boost, ogre, myguiSvn, ois, SDL, libvorbis, pkgconfig }:

throw "Stunt Rally needs ogre with cg support at runtime - we have to package nvidia cg"

stdenv.mkDerivation rec {
  name = "stunt-rally-1.4";

  src = fetchurl {
    url = mirror://sourceforge/stuntrally/StuntRally-1.4-sources.tar.bz2;
    sha256 = "1am5af4l1qliyrq1183sqvwzqwcjx0v6gkzsxhfmk6ygp7yhw7kq";
  };

  buildInputs = [ cmake boost ogre myguiSvn ois SDL libvorbis pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    description = "Stunt Rally game with Track Editor, based on VDrift and OGRE";
    homepage = http://code.google.com/p/vdrift-ogre/;
    license = "GPLv3+";
  };
}
