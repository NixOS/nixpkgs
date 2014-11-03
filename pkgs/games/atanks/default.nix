x@{builderDefsPackage
  , allegro
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="atanks";
    version = "6.0";
    name="${baseName}-${version}";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${baseName}/${name}/${name}.tar.gz";
    sha256 = "0460zwzd800vcgsmd1dzb7j5wcy3lf9hsdw152f6p2mbd0nq5pds";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.sha256;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["fixInstall" "doMakeInstall"];
  makeFlags=[
    "PREFIX=$out/"
  ];
  fixInstall = a.fullDepEntry (''
    sed -e "s@INSTALL=.*bin/install @INSTALL=install @" -i Makefile
    sed -e "s@-g 0 -m ... -o 0@@" -i Makefile
    sed -e 's@/usr/@'"$out"'@g' -i Makefile
  '') ["doUnpack" "minInit"];
      
  meta = {
    description = "Atomic Tanks ballistics game";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    downloadPage = "http://sourceforge.net/projects/atanks/files/atanks/";
    inherit version;
  };
}) x

