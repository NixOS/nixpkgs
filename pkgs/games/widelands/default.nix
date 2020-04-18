{ stdenv, fetchurl, cmake, python, gettext
, boost, libpng, zlib, glew, lua, doxygen, icu
, SDL2, SDL2_image, SDL2_mixer, SDL2_net, SDL2_ttf
}:

stdenv.mkDerivation rec {
  pname = "widelands";
  version = "20";

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

  patches = [
    ./bincmake.patch
  ];

  src = fetchurl {
    url = "https://launchpad.net/widelands/build${version}/build${version}/+download/widelands-build${version}.tar.bz2";
    sha256 = "1cmwfwk7j6yi2pwmm4rm57s23sdzasqf53nx6567sdagqyc4sn9q";
  };

  preConfigure = ''
    cmakeFlags="
      -DWL_INSTALL_BASEDIR=$out
      -DWL_INSTALL_DATADIR=$out/share/widelands
      -DWL_INSTALL_BINARY=$out/bin
    "
  '';

  nativeBuildInputs = [ cmake python gettext ];

  buildInputs = [
    boost libpng zlib glew lua doxygen icu
    SDL2 SDL2_image SDL2_mixer SDL2_net SDL2_ttf
  ];

  prePatch = ''
    substituteInPlace ./debian/org.widelands.widelands.desktop --replace "/usr/share/games/widelands/data/" "$out/share/widelands/"
  '';

  postInstall = ''
    mkdir -p "$out/share/applications/"
    cp -v "../debian/org.widelands.widelands.desktop" "$out/share/applications/"
  '';

  enableParallelBuilding = true;
}
