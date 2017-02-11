{stdenv, fetchurl
  , freeglut, ghostscriptX, imagemagick, fftw 
  , boehmgc, mesa_glu, mesa_noglu, ncurses, readline, gsl, libsigsegv
  , python, zlib, perl, texLive, texinfo, xz
, darwin
}:

let
  s = # Generated upstream information
  rec {
    baseName="asymptote";
    version="2.39";
    name="${baseName}-${version}";
    hash="187q81yw06x4gv2spfn0hcs1064ym3a8l6mdgawymfhqd60yhrs3";
    url="https://netcologne.dl.sourceforge.net/project/asymptote/2.39/asymptote-2.39.src.tgz";
    sha256="187q81yw06x4gv2spfn0hcs1064ym3a8l6mdgawymfhqd60yhrs3";
  };
  buildInputs = [
   ghostscriptX imagemagick fftw
   boehmgc ncurses readline gsl libsigsegv
   python zlib perl texLive texinfo xz ]
   ++ stdenv.lib.optionals stdenv.isLinux
     [ freeglut mesa_glu mesa_noglu mesa_noglu.osmesa ]
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
