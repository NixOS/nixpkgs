{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, util-linux
, libGL
, freetype
, pugixml
, SDL2
, SDL2_image
, openal
, libogg
, libvorbis
, libGLU
, synfigstudio
, inkscape
, imagemagick
, pngquant
, xz
}:

stdenv.mkDerivation rec {
  pname = "hikounomizu";
  version = "0.9.2";

  src = fetchurl {
    url = "http://download.tuxfamily.org/hnm/${version}/hikounomizu-${version}-src.tar.bz2";
    hash = "sha256-ZtvzQAiYG4IcdgKiBDIQFOJVnLbz1TsiIbdZr/0Y2U8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    # for make data
    util-linux
    synfigstudio.synfig
    inkscape
    imagemagick
    pngquant
    xz
  ];

  buildInputs = [
    libGL
    freetype
    pugixml
    SDL2
    SDL2_image
    openal
    libogg
    libvorbis
    libGLU
  ];

  postBuild = ''
    make data -j$NIX_BUILD_CORES
  '';

  meta = with lib; {
    description = "A free platform-based fighting game";
    longDescription = ''
      Hikou no mizu (ハイクの水) is a free platform-based fighting game,
      licensed under the GNU GPL v3 (program) and the LAL (graphics).
      It works on many operating systems including GNU/Linux, *BSD, Haiku,
      OS X and Windows.

      The characters use natural powers such as water or lightning,
      but they can also (mostly for now) fight the traditional way!
    '';
    homepage = "https://hikounomizu.org/";
    downloadPage = "https://hikounomizu.org/download.html";
    maintainers = with maintainers; [ fgaz ];
    license = [ licenses.gpl3Plus licenses.lal13 ];
    platforms = platforms.all;
  };
}
