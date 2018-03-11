{stdenv, fetchurl
  , freeglut, ghostscriptX, imagemagick, fftw 
  , boehmgc, libGLU, libGL, mesa_noglu, ncurses, readline, gsl, libsigsegv
  , python, zlib, perl, texLive, texinfo, xz
, darwin
}:

let
  s = # Generated upstream information
  rec {
    baseName="asymptote";
    version="2.41";
    name="${baseName}-${version}";
    hash="1w7fbq6gy65g0mxg6wdxi7v178c5yxvh9yrnv3bzm4sjzf4pwvhx";
    url="https://freefr.dl.sourceforge.net/project/asymptote/2.41/asymptote-2.41.src.tgz";
    sha256="1w7fbq6gy65g0mxg6wdxi7v178c5yxvh9yrnv3bzm4sjzf4pwvhx";
  };
  buildInputs = [
   ghostscriptX imagemagick fftw
   boehmgc ncurses readline gsl libsigsegv
   python zlib perl texLive texinfo xz ]
   ++ stdenv.lib.optionals stdenv.isLinux
     [ freeglut libGLU libGL mesa_noglu.osmesa ]
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

    rm -rf "$out"/share/texmf
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (s) version;
    description =  "A tool for programming graphics intended to replace Metapost";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raskin maintainers.peti ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
