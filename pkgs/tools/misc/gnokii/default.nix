a :  
let 
  fetchurl = a.fetchurl;

  s = import ./src-for-default.nix; 
  buildInputs = with a; [
    perl intltool gettext libusb
    glib pkgconfig
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = [ "setDebug" "doConfigure" "doMakeInstall"];

  setDebug = a.fullDepEntry ''
    mkdir -p $out/src
    cp -R * $out/src
    cd $out/src

    export NIX_STRIP_DEBUG=0
    export CFLAGS="-ggdb -O0 -include ${a.stdenv.glibc}/include/locale.h"
    export CXXFLAGS="-ggdb -O0"

    patch -p 1 < ${/tmp/patch}
  '' [ "minInit" "doUnpack" ];
      
  inherit(s) name;
  meta = {
    description = "Cellphone tool";
    maintainers = [a.lib.maintainers.raskin];
    platforms = with a.lib.platforms; linux;
  };
}
