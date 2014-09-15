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
    version = "0.8";
    name="${baseName}-${version}";
    url="http://ioping.googlecode.com/files/${name}.tar.gz";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "0j7yal61nby1lkg9wnr6lxfljbd7wl3n0z8khqwvc9lf57bxngz2";
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
    downloadPage = "http://code.google.com/p/ioping/downloads/list";
    inherit version;
  };
}) x

