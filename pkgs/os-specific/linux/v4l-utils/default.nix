x@{builderDefsPackage
  , libv4l, libjpeg, qt4
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="v4l-utils";
    version="0.8.5";
    name="${baseName}-${version}";
    url="http://www.linuxtv.org/downloads/v4l-utils/${name}.tar.bz2";
    hash="0k2rkra8lyimj6bwm8khq6xrhjdy67d09blxa6brnj7kpa7q81f2";
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
  phaseNames = ["doUnpack" "doMakeInstall"];

  makeFlags = [''PREFIX="" DESTDIR="$out"''];
      
  meta = {
    description = "Video-4-Linux utilities";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.linuxtv.org/downloads/v4l-utils/";
    };
  };
}) x

