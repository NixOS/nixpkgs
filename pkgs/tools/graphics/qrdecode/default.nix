args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  fullDepEntry = args.fullDepEntry;

  version = lib.attrByPath ["version"] "0.9.3" args; 
  buildInputs = with args; [
    libpng opencv
  ];
in
rec {
  src = fetchurl {
    url = "ftp://ftp.debian.org/debian/pool/main/libd/libdecodeqr/libdecodeqr_${version}.orig.tar.gz";
    sha256 = "1kmljwx69h7zq6zlp2j19bbpz11px45z1abw03acrxjyzz5f1f13";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["preConfigure" "doConfigure" "doMake" 
  "createDirs"  "doMakeInstall" "postInstall"];

  preConfigure = fullDepEntry ''
    cd src
    sed -e /LDCONFIG/d -i libdecodeqr/Makefile.in
  '' ["doUnpack"];
  postInstall = fullDepEntry ''
    cp sample/simple/simpletest $out/bin/qrdecode 
    cd ..
  '' ["doMake"];
  createDirs = fullDepEntry ''
    ensureDir $out/bin $out/lib $out/include $out/share
  '' ["defEnsureDir"];

  name = "libdecodeqr-" + version;
  meta = {
    description = "QR code decoder library";
  };
}
