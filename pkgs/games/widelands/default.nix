{ stdenv, fetchurl, cmake, python, gettext
, boost, libpng, zlib, glew, lua, doxygen, icu
, SDL2, SDL2_image, SDL2_mixer, SDL2_net, SDL2_ttf, SDL2_gfx
}:

stdenv.mkDerivation rec {
  name = "widelands-${version}";
  version = "19";

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
    url = "https://launchpad.net/widelands/build${version}/build${version}/+download/"
        + "widelands-build${version}-src.tar.bz2";
    sha256 = "19h1gina7k1ai2mn2fd75lxm8iz8wrs6dz6dchdvg8i8d39gj4g5";
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
    substituteInPlace ./debian/widelands.desktop --replace "/usr/share/games/widelands/data/" "$out/share/widelands/"
  '';

  postInstall = ''
    mkdir -p "$out/share/applications/"
    cp -v "../debian/widelands.desktop" "$out/share/applications/"
  '';

  enableParallelBuilding = true;
}
