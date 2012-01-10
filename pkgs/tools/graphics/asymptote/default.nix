a @ {
  freeglut,ghostscriptX,imagemagick,fftw,
  boehmgc,mesa,ncurses,readline,gsl,libsigsegv,
  python,zlib, perl, texLive, texinfo, lzma,

  noDepEntry, fullDepEntry, fetchUrlFromSrcInfo, 
  lib,

  ...}:
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    freeglut ghostscriptX imagemagick fftw boehmgc
    mesa ncurses readline gsl libsigsegv python zlib
    perl texLive texinfo lzma
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = "--enable-gc=${a.boehmgc} --enable-offscreen";

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doUnpack" "fixPaths" "extractTexinfoTex"
    "doConfigure" "dumpRealVars" "doMakeInstall" "fixPathsResult"
    "fixInfoDir"];

  setVars = a.noDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${a.boehmgc}/include/gc"
    export HOME="$PWD"
  '';

  dumpRealVars = a.noDepEntry ''
    set > ../real-env-vars
  '';

  fixPaths = a.doPatchShebangs ''.'';
  fixPathsResult = a.doPatchShebangs ''$out/bin'';

  fixInfoDir = a.noDepEntry ''
    mv -v "$out/share/info/asymptote/"*.info $out/share/info/
    sed -i -e 's|(asymptote/asymptote)|(asymptote)|' $out/share/info/asymptote.info
    rmdir $out/share/info/asymptote
    rm $out/share/info/dir
  '';

  extractTexinfoTex = a.fullDepEntry ''
    lzma -d < ${a.texinfo.src} | tar --wildcards -x texinfo-'*'/doc/texinfo.tex
    cp texinfo-*/doc/texinfo.tex doc/
  '' ["minInit" "addInputs" "doUnpack"];

  meta = {
    description = "A tool for programming graphics intended to replace Metapost";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };
}
