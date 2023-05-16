<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub
, autoreconfHook, bison, glm, flex, wrapQtAppsHook, cmake
, freeglut, ghostscriptX, imagemagick, fftw
, boehmgc, libGLU, libGL, mesa, ncurses, readline, gsl, libsigsegv
, python3, qtbase, qtsvg, boost
=======
{ lib, stdenv, fetchFromGitHub, fetchurl, fetchpatch
, autoreconfHook, bison, glm, flex
, freeglut, ghostscriptX, imagemagick, fftw
, boehmgc, libGLU, libGL, mesa, ncurses, readline, gsl, libsigsegv
, python3Packages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, zlib, perl, curl
, texLive, texinfo
, darwin
}:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "2.86";
=======
  version = "2.85";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "asymptote";

  src = fetchFromGitHub {
    owner = "vectorgraphics";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Bk8/WIQTfrbOo9b2hw580vJwiK6P1OBV5HMqMH+LkuE=";
=======
    hash = "sha256-GyW9OEolV97WtrSdIxp4MCP3JIyA1c/DQSqg8jLC0WQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    bison
    texinfo
<<<<<<< HEAD
    wrapQtAppsHook
    cmake
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    ghostscriptX imagemagick fftw
    boehmgc ncurses readline gsl libsigsegv
<<<<<<< HEAD
    zlib perl curl qtbase qtsvg boost
    texLive
    (python3.withPackages (ps: with ps; [ cson numpy pyqt5 ]))
  ];
=======
    zlib perl curl
    texLive
  ] ++ (with python3Packages; [
    python
    pyqt5
  ]);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    glm
  ] ++ lib.optionals stdenv.isLinux [
    freeglut libGLU libGL mesa.osmesa
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    OpenGL GLUT Cocoa
  ]);

<<<<<<< HEAD
  dontWrapQtApps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preConfigure = ''
    HOME=$TMP
  '';

  configureFlags = [
    "--with-latex=$out/share/texmf/tex/latex"
    "--with-context=$out/share/texmf/tex/context/third"
  ];

  env.NIX_CFLAGS_COMPILE = "-I${boehmgc.dev}/include/gc";

  postInstall = ''
<<<<<<< HEAD
    rm "$out"/bin/xasy
    makeQtWrapper "$out"/share/asymptote/GUI/xasy.py "$out"/bin/xasy --prefix PATH : "$out"/bin

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mv $out/share/info/asymptote/*.info $out/share/info/
    sed -i -e 's|(asymptote/asymptote)|(asymptote)|' $out/share/info/asymptote.info
    rmdir $out/share/info/asymptote
    rm -f $out/share/info/dir

    rm -rf $out/share/texmf
    install -Dt $out/share/emacs/site-lisp/${pname} $out/share/asymptote/*.el
  '';

<<<<<<< HEAD
  dontUseCmakeConfigure = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  enableParallelBuilding = true;
  # Missing install depends:
  #   ...-coreutils-9.1/bin/install: cannot stat 'asy-keywords.el': No such file or directory
  #   make: *** [Makefile:272: install-asy] Error 1
  enableParallelInstalling = false;

  meta = with lib; {
    description =  "A tool for programming graphics intended to replace Metapost";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
