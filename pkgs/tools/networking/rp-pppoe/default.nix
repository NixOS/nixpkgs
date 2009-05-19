a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.getAttr ["version"] "3.10" a; 
  buildInputs = with a; [
    ppp   
  ];
in
rec {
  src = fetchurl {
    url = "http://www.roaringpenguin.com/files/download/rp-pppoe-${version}.tar.gz";
    sha256 = "1xj9rvsblvv2zi4n1bj8mkk00p1b24ch5hlr1gcc3b4l4m0ag73h";
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
    ensureDir $out/share/${name}/etc/ppp
  '') ["minInit" "defEnsureDir"];

  name = "rp-pppoe-" + version;
  meta = {
    description = "Roaring Penguin Point-to-Point over Ethernet tool";
  };
}
