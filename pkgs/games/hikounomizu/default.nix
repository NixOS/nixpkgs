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
, enet
, synfigstudio
, inkscape
, imagemagick
, pngquant
, xz
, bc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hikounomizu";
  version = "1.0.1";

  src = fetchurl {
    url = "http://download.tuxfamily.org/hnm/${finalAttrs.version}/hikounomizu-${finalAttrs.version}-src.tar.bz2";
    hash = "sha256-3wRhe6CDq1dD0SObAygfqslYJx+EM3LM3rj6HI0whYU=";
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
    bc
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
    enet
  ];

  postBuild = ''
    make data HNM_PARALLEL=$NIX_BUILD_CORES
  '';

  meta = with lib; {
    description = "Free platform-based fighting game";
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
})
