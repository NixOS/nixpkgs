{stdenv, fetchurl, fetchpatch
  , freeglut, ghostscriptX, imagemagick, fftw
  , boehmgc, libGLU, libGL, mesa, ncurses, readline, gsl, libsigsegv
  , python, zlib, perl, texLive, texinfo, xz
, darwin
}:

let
  s = # Generated upstream information
  rec {
    baseName="asymptote";
    version="2.47";
    name="${baseName}-${version}";
    hash="0zc24n2vwzxdfmcppqfk3fkqlb4jmvswzi3bz232kxl7dyiyb971";
    url="https://freefr.dl.sourceforge.net/project/asymptote/2.47/asymptote-2.47.src.tgz";
    sha256="0zc24n2vwzxdfmcppqfk3fkqlb4jmvswzi3bz232kxl7dyiyb971";
  };
  buildInputs = [
   ghostscriptX imagemagick fftw
   boehmgc ncurses readline gsl libsigsegv
   python zlib perl texLive texinfo xz ]
   ++ stdenv.lib.optionals stdenv.isLinux
     [ freeglut libGLU libGL mesa.osmesa ]
   ++ stdenv.lib.optionals stdenv.isDarwin
     (with darwin.apple_sdk.frameworks; [ OpenGL GLUT Cocoa ])
   ;
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;

  src = fetchurl {
    inherit (s) url sha256;
  };

  patches = [
    # Remove when updating from 2.47 to 2.48
    # Compatibility with BoehmGC 7.6.8
    (fetchpatch {
      url = "https://github.com/vectorgraphics/asymptote/commit/38a59370dc5ac720c29e1424614a10f7384b943f.patch";
      sha256 = "0c3d11hzxxaqh24kfw9y8zvlid54kk40rx2zajx7jwl12gga05s1";
    })
  ];

  preConfigure = ''
    export HOME="$PWD"
    patchShebangs .
    sed -e 's@epswrite@eps2write@g' -i runlabel.in
    xz -d < ${texinfo.src} | tar --wildcards -x texinfo-'*'/doc/texinfo.tex
    cp texinfo-*/doc/texinfo.tex doc/
    rm *.tar.gz
    configureFlags="$configureFlags --with-latex=$out/share/texmf/tex/latex --with-context=$out/share/texmf/tex/context/third"
  '';

  NIX_CFLAGS_COMPILE = [ "-I${boehmgc.dev}/include/gc" ];

  postInstall = ''
    mv -v "$out/share/info/asymptote/"*.info $out/share/info/
    sed -i -e 's|(asymptote/asymptote)|(asymptote)|' $out/share/info/asymptote.info
    rmdir $out/share/info/asymptote
    rm $out/share/info/dir

    rm -rfv "$out"/share/texmf
    mkdir -pv "$out"/share/emacs/site-lisp/${s.name}
    mv -v "$out"/share/asymptote/*.el "$out"/share/emacs/site-lisp/${s.name}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (s) version;
    description =  "A tool for programming graphics intended to replace Metapost";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raskin maintainers.peti ];
    broken = stdenv.isDarwin;  # https://github.com/vectorgraphics/asymptote/issues/69
    platforms = platforms.linux ++ platforms.darwin;
  };
}
