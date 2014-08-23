a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "3.11" a;
  buildInputs = with a; [
    ppp   
  ];
in
rec {
  src = fetchurl {
    url = "http://www.roaringpenguin.com/files/download/rp-pppoe-${version}.tar.gz";
    sha256 = "083pfjsb8w7afqgygbvgndwajgwkfmcnqla5vnk4z9yf5zcs98c6";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["exportVars" "doConfigure" "patchInstall" "makeDirs" "doMakeInstall"];

  goSrcDir = "cd src";
  exportVars = a.noDepEntry(''
    export PATH="$PATH:${a.ppp}/sbin"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -L${a.ppp}/lib/${a.ppp.version}"
    export PPPD=${a.ppp}/sbin/pppd
  '');

  patchInstall = a.fullDepEntry(''
    sed -i Makefile -e 's@DESTDIR)/etc/ppp@out)/share/${name}/etc/ppp@'
    sed -i Makefile -e 's@PPPOESERVER_PPPD_OPTIONS=@&$(out)/share/${name}@'
  '') ["minInit" "doUnpack"];

  makeDirs = a.fullDepEntry(''
    mkdir -p $out/share/${name}/etc/ppp
  '') ["minInit" "defEnsureDir"];

  name = "rp-pppoe-" + version;
  meta = {
    description = "Roaring Penguin Point-to-Point over Ethernet tool";
  };
}
