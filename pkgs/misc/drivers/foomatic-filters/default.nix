x@{builderDefsPackage
  , perl, cups
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="foomatic-filters";
    version="4.0.6";
    name="${baseName}-${version}";
    url="http://www.openprinting.org/download/foomatic/${name}.tar.gz";
    hash="0wa9hlq7s99sh50kl6bj8j0vxrz7pcbwdnqs1yfjjhqshfh7hsav";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["doConfigure" "fixPaths" "doMakeInstall"];

  fixPaths = a.fullDepEntry ''
    sed -e "s@= .*/store/[^/]\+/lib/cups/filter@= $out/lib/cups/filter@" -i Makefile
    sed -e "s@= .*/store/[^/]\+/lib/cups/backend@= $out/lib/cups/backend@" -i Makefile
    sed -e "s@= /usr/@= $out/@" -i Makefile
  '' ["doConfigure" "minInit"];
      
  meta = {
    description = "Foomatic printing filters";
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
      downloadPage = "http://www.openprinting.org/download/foomatic/";
    };
  };
}) x

