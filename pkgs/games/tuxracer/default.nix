a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.61" a; 
  buildInputs = with a; [
    mesa libX11 xproto tcl freeglut
  ];
in
rec {
  src = fetchurl {
    url = "http://downloads.sourceforge.net/tuxracer/tuxracer-${version}.tar.gz";
    sha256 = "1zqyz4ig0kax5q30vcgbavcjw36wsyp9yjsd2dbfb3srh28d04d3";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];

  preConfigure = a.fullDepEntry (''
    sed -e '/TCL_LIB_LIST=/atcl8.4' -i configure
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DGLX_GLXEXT_LEGACY=1"
  '') ["minInit" "doUnpack"];
      
  name = "tuxracer-" + version;
  meta = {
    description = "TuxRacer - Tux lies on his belly and accelerates down ice slopes..";
  };
}
