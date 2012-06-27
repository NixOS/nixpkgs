x@{builderDefsPackage
  , tcp_wrappers
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="tftp-hpa";
    version="5.2";
    name="${baseName}-${version}";
    url="mirror://kernel/software/network/tftp/tftp-hpa/${name}.tar.xz";
    hash="afee361df96a2f88344e191f6a25480fd714e1d28d176c3f10cc43fa206b718b";
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
    description = "TFTP tools - a lot of fixes on top of BSD TFTP";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.bsd3;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.kernel.org/pub/software/network/tftp/";
    };
  };
}) x

