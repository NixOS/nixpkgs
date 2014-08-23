{ stdenv, fetchurl, cmake, python, gettext
, boost, libpng, zlib, glew, lua
, SDL, SDL_image, SDL_mixer, SDL_net, SDL_ttf, SDL_gfx
}:

stdenv.mkDerivation {
  name = "widelands-18";

  meta = with stdenv.lib; {
    description = "RTS with multiple-goods economy";
    homepage    = "http://widelands.org/";
    longDescription = ''
      Widelands is a real time strategy game based on "The Settlers" and "The
      Settlers II". It has a single player campaign mode, as well as a networked
      multiplayer mode.
    '';
    license        = licenses.gpl2Plus;
    platforms      = platforms.linux;
    maintainers    = with maintainers; [ raskin jcumming ];
    hydraPlatforms = [];
  };


  src = fetchurl {
    url = "https://launchpad.net/widelands/build18/build-18/+download/"
        + "widelands-build18-src.tar.bz2";
    sha256 = "1qvx1cwkf61iwq0qkngvg460dsxqsfvk36qc7jf7mzwkiwbxkzvd";
  };

  preConfigure = ''
    cmakeFlags="
      -DWL_INSTALL_PREFIX=$out
      -DWL_INSTALL_BINDIR=bin
      -DWL_INSTALL_DATADIR=share/widelands
    "
  '';

  nativeBuildInputs = [ cmake python gettext ];

  buildInputs = [
    boost libpng zlib glew lua
    SDL SDL_image SDL_mixer SDL_net SDL_ttf SDL_gfx
  ];

  enableParallelBuilding = true;
}
