x@{builderDefsPackage
  , openssl, tdb, zlib, flex, bison
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="fdm";
    version="1.7";
    name="${baseName}-${version}";
    url="mirror://sourceforge/${baseName}/${baseName}/${name}.tar.gz";
    hash="0apg1jasn4m5j3vh0v9lr2l3lyzy35av1ylxr0wf8k0j9w4p8i28";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["doConfigure" "fixInstall" "doMakeInstall"];
  makeFlags = ["PREFIX=$out"];
  fixInstall = a.fullDepEntry (''
    sed -i */Makefile -i Makefile -e 's@ -g bin @ @'
    sed -i */Makefile -i Makefile -e 's@ -o root @ @'
    sed -i GNUmakefile -e 's@ -g $(BIN_OWNER) @ @'
    sed -i GNUmakefile -e 's@ -o $(BIN_GROUP) @ @'
    sed -i */Makefile -i Makefile -i GNUmakefile -e 's@-I-@@g'
  '') ["minInit" "doUnpack"];
      
  meta = {
    description = "Mail fetching and delivery tool - should do the job of getmail and procmail";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://fdm.sourceforge.net/";
    };
  };
}) x

