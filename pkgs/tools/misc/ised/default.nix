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
    baseName="ised";
    version = "2.6.0";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/ised/${name}.tar.bz2";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "0rf9brqkrad8f3czpfc1bxq9ybv3nxci9276wdxas033c82cqkjs";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "A numeric sequence editor";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl3Plus;
    inherit version;
  };
}) x

