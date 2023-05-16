<<<<<<< HEAD
{ lib, stdenv, fetchhg
=======
{ lib, stdenv, fetchzip
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, autoreconfHook
, boost
, freeglut
, glew
, gsl
, lcms2
, libpng
, libtiff
, libGLU
, libGL
, vigra
, help2man
, pkg-config
, perl
, texlive
}:

stdenv.mkDerivation rec {
  pname = "enblend-enfuse";
  version = "unstable-2022-03-06";

<<<<<<< HEAD
  src = fetchhg {
    url = "http://hg.code.sf.net/p/enblend/code";
    rev = "0f423c72e51872698fe2985ca3bd453961ffe4e0";
    sha256 = "sha256-0gCUSdg3HR3YeIbOByEBCZh2zGlYur6DeCOzUM53fdc=";
=======
  src = fetchzip {
    url = "https://sourceforge.net/code-snapshots/hg/e/en/enblend/code/enblend-code-0f423c72e51872698fe2985ca3bd453961ffe4e0.zip";
    sha256 = "sha256-0gCUSdg3HR3YeIbOByEBCZh2zGlYur6DeCOzUM53fdc=";
    stripRoot = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ boost freeglut glew gsl lcms2 libpng libtiff libGLU libGL vigra ];

  nativeBuildInputs = [ autoreconfHook help2man perl pkg-config texlive.combined.scheme-small ];

  preConfigure = ''
    patchShebangs src/embrace
  '';

  meta = with lib; {
    homepage = "https://enblend.sourceforge.net/";
    description = "Blends away the seams in a panoramic image mosaic using a multiresolution spline";
    license = licenses.gpl2;
    platforms = with platforms; linux;
  };
}
