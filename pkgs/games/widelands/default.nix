{ lib, stdenv, fetchurl, cmake, python, gettext
, boost, libpng, zlib, glew, lua, doxygen, icu
, SDL2, SDL2_image, SDL2_mixer, SDL2_net, SDL2_ttf
}:

stdenv.mkDerivation rec {
  pname = "widelands";
  version = "21";

  meta = with lib; {
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
    url = "https://launchpad.net/widelands/build${version}/build${version}/+download/widelands-build${version}-source.tar.gz";
    sha256 = "sha256-YB4OTG+Rs/sOzizRuD7PsCNEobkZT7tw7z9w4GmU41c=";
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

  postInstall = ''
    mkdir -p "$out/share/applications/"
    cp -v "../xdg/org.widelands.Widelands.desktop" "$out/share/applications/"
  '';
}
