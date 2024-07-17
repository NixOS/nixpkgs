{
  lib,
  stdenv,
  fetchhg,
  autoreconfHook,
  boost,
  freeglut,
  glew,
  gsl,
  lcms2,
  libpng,
  libtiff,
  libGLU,
  libGL,
  vigra,
  help2man,
  pkg-config,
  perl,
  texliveSmall,
}:

stdenv.mkDerivation rec {
  pname = "enblend-enfuse";
  version = "unstable-2022-03-06";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/enblend/code";
    rev = "0f423c72e51872698fe2985ca3bd453961ffe4e0";
    sha256 = "sha256-0gCUSdg3HR3YeIbOByEBCZh2zGlYur6DeCOzUM53fdc=";
  };

  buildInputs = [
    boost
    freeglut
    glew
    gsl
    lcms2
    libpng
    libtiff
    libGLU
    libGL
    vigra
  ];

  nativeBuildInputs = [
    autoreconfHook
    help2man
    perl
    pkg-config
    texliveSmall
  ];

  preConfigure = ''
    patchShebangs src/embrace
  '';

  meta = with lib; {
    homepage = "https://enblend.sourceforge.net/";
    description = "Blends away the seams in a panoramic image mosaic using a multiresolution spline";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
  };
}
