x@{builderDefsPackage
  , libewf, afflib, openssl, zlib
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="sleuthkit";
    version="3.2.2";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/${baseName}/${baseName}/${version}/${name}.tar.gz";
    hash="02hik5xvbgh1dpisvc3wlhhq1aprnlsk0spbw6h5khpbq9wqnmgj";
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
    description = "A forensic/data recovery tool";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "IBM Public License";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/sleuthkit/files/sleuthkit";
    };
  };
}) x

