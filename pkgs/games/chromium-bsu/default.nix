{
  lib,
  stdenv,
  fetchurl,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  fontconfig,
  freealut,
  freeglut,
  ftgl,
  gettext,
  glpng,
  libGL,
  libGLU,
  openal,
  pkg-config,
  quesoglc,
}:

stdenv.mkDerivation rec {
  pname = "chromium-bsu";
  version = "0.9.16.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/chromium-bsu/Chromium%20B.S.U.%20source%20code/${pname}-${version}.tar.gz";
    hash = "sha256-ocFBo00ZpZYHroEWahmGTrjITPhrFVRi/tMabVbhYko=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
  ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    fontconfig
    freealut
    freeglut
    ftgl
    glpng
    libGL
    libGLU
    openal
    quesoglc
  ];

  # Autodetection is somewhat buggy; this is to avoid SLD1 to be loaded
  configureFlags = [
    "--disable-sdlimage"
    "--disable-sdlmixer"
  ];

  postInstall = ''
    install -D misc/chromium-bsu.png $out/share/pixmaps/chromium-bsu.png
    install -D misc/chromium-bsu.desktop $out/share/applications/chromium-bsu.desktop
  '';

  meta = with lib; {
    homepage = "http://chromium-bsu.sourceforge.net/";
    description = "A fast paced, arcade-style, top-scrolling space shooter";
    mainProgram = "chromium-bsu";
    license = licenses.artistic1;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO [ AndersonTorres ]: joystick; gothic uralic font
