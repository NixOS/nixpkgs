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
    version = "0.99";
    baseName="barcode";
    name="${baseName}-${version}";
    url="mirror://gnu/${baseName}/${name}.tar.xz";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "1indapql5fjz0bysyc88cmc54y8phqrbi7c76p71fgjp45jcyzp8";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "GNU barcode generator";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms; allBut darwin;
    downloadPage = "http://ftp.gnu.org/gnu/barcode/";
    updateWalker = true;
    inherit version;
  };
}) x

