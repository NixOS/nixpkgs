{ stdenv, fetchFromGitHub, fetchurl
, autoreconfHook, bison, glm, yacc, flex
, freeglut, ghostscriptX, imagemagick, fftw
, boehmgc, libGLU, libGL, mesa, ncurses, readline, gsl, libsigsegv
, python3Packages
, zlib, perl
, texLive, texinfo
, darwin
}:

stdenv.mkDerivation rec {
  version = "2.63";
  pname = "asymptote";

  src = fetchFromGitHub {
    owner = "vectorgraphics";
    repo = pname;
    rev = version;
    sha256 = "1szy0hmh8fx73ngpfn5p934snv148kf1amdnbcjc0n5zb4x9vzck";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    yacc
    texinfo
  ];

  buildInputs = [
    ghostscriptX imagemagick fftw
    boehmgc ncurses readline gsl libsigsegv
    zlib perl
    texLive
  ] ++ (with python3Packages; [
    python
    pyqt5
  ]);

  propagatedBuildInputs = [
    glm
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    freeglut libGLU libGL mesa.osmesa
  ] ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    OpenGL GLUT Cocoa
  ]);

  preConfigure = ''
    HOME=$TMP
  '';

  configureFlags = [
    "--with-latex=$out/share/texmf/tex/latex"
    "--with-context=$out/share/texmf/tex/context/third"
  ];

  NIX_CFLAGS_COMPILE = "-I${boehmgc.dev}/include/gc";

  postInstall = ''
    mv $out/share/info/asymptote/*.info $out/share/info/
    sed -i -e 's|(asymptote/asymptote)|(asymptote)|' $out/share/info/asymptote.info
    rmdir $out/share/info/asymptote
    rm -f $out/share/info/dir

    rm -rf $out/share/texmf
    install -Dt $out/share/emacs/site-lisp/${pname} $out/share/asymptote/*.el
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description =  "A tool for programming graphics intended to replace Metapost";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raskin maintainers.peti ];
    broken = stdenv.isDarwin;  # https://github.com/vectorgraphics/asymptote/issues/69
    platforms = platforms.linux ++ platforms.darwin;
  };
}
