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
    version="5.1";
    name="${baseName}-${version}";
    url="mirror://kernel/software/network/tftp/${name}.tar.bz2";
    hash="0k72s0c7wm4fyb6lqfypdkcy6rimanr49slimx8p0di69w394gzx";
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

