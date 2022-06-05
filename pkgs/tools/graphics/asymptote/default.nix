{ lib, stdenv, fetchFromGitHub, fetchurl, fetchpatch
, autoreconfHook, bison, glm, flex
, freeglut, ghostscriptX, imagemagick, fftw
, boehmgc, libGLU, libGL, mesa, ncurses, readline, gsl, libsigsegv
, python3Packages
, zlib, perl, curl
, texLive, texinfo
, darwin
}:

stdenv.mkDerivation rec {
  version = "2.67";
  pname = "asymptote";

  src = fetchFromGitHub {
    owner = "vectorgraphics";
    repo = pname;
    rev = version;
    hash = "sha256-dMgsKBg6YQ3mdx3jFqjX4vZeizaier8+ZQUl4J6QXNE=";
  };

  patches =
    (lib.optional (lib.versionOlder version "2.68")
      (fetchpatch {
        url = "https://github.com/vectorgraphics/asymptote/commit/3361214340d58235f4dbb8f24017d0cd5d94da72.patch";
        hash = "sha256-1RYMZcwbjBAM7aAXFBbwst0eozWYFtJ8HcicjXogS/w=";
      }))
  ;

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    bison
    texinfo
  ];

  buildInputs = [
    ghostscriptX imagemagick fftw
    boehmgc ncurses readline gsl libsigsegv
    zlib perl curl
    texLive
  ] ++ (with python3Packages; [
    python
    pyqt5
  ]);

  propagatedBuildInputs = [
    glm
  ] ++ lib.optionals stdenv.isLinux [
    freeglut libGLU libGL mesa.osmesa
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
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

  meta = with lib; {
    description =  "A tool for programming graphics intended to replace Metapost";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raskin ];
    broken = stdenv.isDarwin;  # https://github.com/vectorgraphics/asymptote/issues/69
    platforms = platforms.linux ++ platforms.darwin;
  };
}
