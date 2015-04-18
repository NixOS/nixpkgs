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
    baseName="ioping";
    version = "0.9";
    name="${baseName}-${version}";
    url="https://docs.google.com/uc?id=0B_PlDc2qaehFWWtLZ3Z3N1ltdm8&export=download";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    name = "${sourceInfo.name}.tar.gz";
    sha256 = "0pbp7b3304y9yyv2w41l3898h5q8w77hnnnq1vz8qz4qfl4467lm";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doMakeInstall"];
  makeFlags = [
    ''PREFIX="$out"''
  ];
      
  meta = {
    description = "Filesystem IO delay time measurer";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl3Plus;
    homepage = "http://code.google.com/p/ioping/";
    inherit version;
  };
}) x

