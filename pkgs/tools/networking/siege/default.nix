x@{builderDefsPackage
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="siege";
    version="2.70";
    name="${baseName}-${version}";
    url="ftp://ftp.joedog.org/pub/siege/${name}.tar.gz";
    hash="14fxfmfsqwyahc91w4vn3n8hvclf78n4k1xllqsrpvjb5asvrd1w";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "createDirs" "doMakeInstall"];

  createDirs = a.fullDepEntry ''
    mkdir -p "$out/"{bin,lib,share/man,etc}
  '' ["defEnsureDir"];

  meta = {
    description = "HTTP load tester";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.joedog.org/index/siege-home";
    };
  };
}) x

