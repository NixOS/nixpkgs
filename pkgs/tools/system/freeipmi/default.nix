x@{builderDefsPackage
  , libgcrypt, readline
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="freeipmi";
    version="1.0.1";
    name="${baseName}-${version}";
    url="http://download.gluster.com/pub/${baseName}/${version}/${name}.tar.gz";
    hash="11j0jvarxvzj89c2fg49ghz75gljdkacid6631q313kc1bd2l0ms";
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
    description = "IPMI utility";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl3;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.gnu.org/software/freeipmi/download.html";
    };
  };
}) x

