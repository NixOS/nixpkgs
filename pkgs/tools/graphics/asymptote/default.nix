a @ {
  freeglut,ghostscriptX,imagemagick,fftw,
  boehmgc,mesa,ncurses,readline,gsl,libsigsegv,
  python,zlib, perl, texLive, texinfo, xz,

  noDepEntry, fullDepEntry, fetchUrlFromSrcInfo,
  lib,

  ...}:
let
  s = # Generated upstream information
  rec {
    baseName="asymptote";
    version="2.32";
    name="${baseName}-${version}";
    hash="19cgn5158p42igjbp8lf6xdbh3yjhlkdm22m5lqrhibp09g06d90";
    url="mirror://sourceforge/project/asymptote/2.32/asymptote-2.32.src.tgz";
    sha256="19cgn5158p42igjbp8lf6xdbh3yjhlkdm22m5lqrhibp09g06d90";
  };
  buildInputs = with a; [
    freeglut ghostscriptX imagemagick fftw boehmgc
    mesa ncurses readline gsl libsigsegv python zlib
    perl texLive texinfo xz
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
    xz -d < ${a.texinfo.src} | tar --wildcards -x texinfo-'*'/doc/texinfo.tex
    cp texinfo-*/doc/texinfo.tex doc/
  '' ["minInit" "addInputs" "doUnpack"];

  meta = {
    inherit (s) version;
    description = "A tool for programming graphics intended to replace Metapost";
    maintainers = [
      a.lib.maintainers.raskin
      a.lib.maintainers.simons
    ];
    platforms = with a.lib.platforms;
      linux;
  };
}
