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
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doUnpack" "fixPaths" "extractTexinfoTex" 
    "doConfigure" "dumpRealVars" "doMakeInstall" "fixPathsResult"];
      
  setVars = a.noDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${a.boehmgc}/include/gc"
    export HOME="$PWD"
  '';

  dumpRealVars = a.noDepEntry ''
    set > ../real-env-vars
  '';

  fixPaths = a.doPatchShebangs ''.'';
  fixPathsResult = a.doPatchShebangs ''$out/bin'';

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
      linux ++ freebsd ++ darwin;
  };
}
