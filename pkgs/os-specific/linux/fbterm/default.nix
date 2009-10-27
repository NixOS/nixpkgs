a :  
let 
  fetchurl = a.fetchurl;
  
  buildInputs = with a; [
    gpm freetype fontconfig pkgconfig ncurses
  ];
  s = import ./src-for-default.nix; 
in
rec {
  src = a.fetchUrlFromSrcInfo s; 
  inherit(s) name;
  inherit buildInputs;
  configureFlags = [];

  fixInc = a.fullDepEntry (''
    sed -e '/ifdef SYS_signalfd/atypedef long long loff_t;' -i src/fbterm.cpp
  '') ["doUnpack" "minInit"];

  fixMakeInstall = a.fullDepEntry (''
    sed -e '/install-exec-hook:/,/^[^\t]/{d}; /.NOEXPORT/iinstall-exec-hook:\
    ' -i src/Makefile.in
  '') ["doUnpack" "minInit"];

  setVars = a.noDepEntry (''
    export HOME=$PWD;
    export NIX_LDFLAGS="$NIX_LDFLAGS -lfreetype"
  '') ;

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "fixInc" "fixMakeInstall" "doConfigure" "doMakeInstall"];
      
  meta = {
    description = "Framebuffer terminal emulator";
    maintainers = [a.lib.maintainers.raskin];
  };
}
