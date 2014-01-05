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
    version="0.7";
    name="${baseName}-${version}";
    url="http://ioping.googlecode.com/files/${name}.tar.gz";
    hash="1c0k9gsq7rr9fqh6znn3i196l84zsm44nq3pl1b7grsnnbp2hki3";
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
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://code.google.com/p/ioping/downloads/list";
    };
  };
}) x

