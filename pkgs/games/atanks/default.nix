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
    version="4.9";
    name="${baseName}-${version}";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${baseName}/${name}/${name}.tar.gz";
    hash="015nwh8jk4k24ci6ilihii8idkyf6g266r4vl50csvykc82slrvd";
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
  phaseNames = ["fixInstall" "doMakeInstall"];
  makeFlags=[
    "PREFIX=$out/"
  ];
  fixInstall = a.fullDepEntry (''
    sed -e "s@INSTALL=.*bin/install @INSTALL=install @" -i Makefile
    sed -e "s@-g 0 -m ... -o 0@@" -i Makefile
  '') ["doUnpack" "minInit"];
      
  meta = {
    description = "Atomic Tanks ballistics game";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/atanks/files/atanks/";
    };
  };
}) x

