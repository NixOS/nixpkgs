{stdenv, fetchurl
  , freeglut, ghostscriptX, imagemagick, fftw 
  , boehmgc, mesa_glu, mesa_noglu, ncurses, readline, gsl, libsigsegv
  , python, zlib, perl, texLive, texinfo, xz
}:

assert stdenv.isLinux;

let
  s = # Generated upstream information
  rec {
    baseName="asymptote";
    version="2.37";
    name="${baseName}-${version}";
    hash="16nh02m52mk9a53i8wc6l9vg710gnzr3lfbypcbvamghvaj0458i";
    url="mirror://sourceforge/project/asymptote/2.37/asymptote-2.37.src.tgz";
    sha256="16nh02m52mk9a53i8wc6l9vg710gnzr3lfbypcbvamghvaj0458i";
  };
  buildInputs = [
   freeglut ghostscriptX imagemagick fftw 
   boehmgc mesa_glu mesa_noglu mesa_noglu.osmesa ncurses readline gsl libsigsegv
   python zlib perl texLive texinfo xz
  ];
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

  NIX_CFLAGS_COMPILE = [ "-I${boehmgc}/include/gc" ];

  postInstall = ''
    mv -v "$out/share/info/asymptote/"*.info $out/share/info/
    sed -i -e 's|(asymptote/asymptote)|(asymptote)|' $out/share/info/asymptote.info
    rmdir $out/share/info/asymptote
    rm $out/share/info/dir
  '';

  enableParallelBuilding = true;

  meta = {
    inherit (s) version;
    description =  "A tool for programming graphics intended to replace Metapost";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [stdenv.lib.maintainers.raskin stdenv.lib.maintainers.simons];
    platforms = stdenv.lib.platforms.linux;
  };
}
