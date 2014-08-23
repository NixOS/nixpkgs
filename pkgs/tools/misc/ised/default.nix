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
    version="2.5.0";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/ised/${name}.tar.bz2";
    hash="1avfb4ivq6iz50rraci0pcxl0w94899sz6icdqc0l4954y4zs8qd";
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
    description = "A numeric sequence editor";
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
      downloadPage = "ised.sf.net";
    };
  };
}) x

