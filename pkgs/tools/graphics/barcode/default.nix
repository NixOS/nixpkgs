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
    version="0.98";
    baseName="barcode";
    name="${baseName}-${version}";
    # mirror://gnu/ doesn't work for this package
    url="http://ftp.gnu.org/gnu/${baseName}/${name}.tar.gz";
    hash="0ddn17a6hz817bchgjxrjg76v64kzl5zlll8x73ply5rg69f2aa2";
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
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "GNU barcode generator";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      all;
  };
  passthru = {
    updateInfo = {
      downloadPage = "ftp://ftp.gnu.org/gnu/barcode/";
    };
  };
}) x

