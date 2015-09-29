{ stdenv, fetchFromGitHub, qt4, ogre, mygui, bullet, ffmpeg, boost, cmake, SDL2, unshield, openal, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.36.1";
  name = "openmw-${version}";

  mygui_ = mygui.overrideDerivation (oldAttrs: {
    name = "mygui-3.2.1";
    version = "3.2.1";

    src = fetchFromGitHub {
      owner = "MyGUI";
      repo = "mygui";
      rev = "MyGUI3.2.1";
      sha256 = "1ic4xwyh2akfpqirrbyvicc56yy2r268rzgcgx16yqb4nrldy2p0";
    };
  });

  src = fetchFromGitHub {
    owner = "OpenMW";
    repo = "openmw";
    rev = name;
    sha256 = "0yfiilad6izmingc0nhvkvn6dpybps04xwj4k1h13ymip6awm80x";
  };

  buildInputs = [ cmake boost ffmpeg qt4 bullet mygui_ ogre SDL2 unshield openal pkgconfig ];

  meta = {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = "http://openmw.org";
    license = stdenv.lib.licenses.gpl3;
  };
  
}
