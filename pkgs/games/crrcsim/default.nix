x@{builderDefsPackage
  , mesa, SDL, SDL_mixer, plib, libjpeg
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="crrcsim";
    version="0.9.11";
    name="${baseName}-${version}";
    url="http://download.berlios.de/${baseName}/${name}.tar.gz";
    hash="16z9gixp60920lqckij8kdw90jys0llls4lw5c8vqgk14ck5hhiz";
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
    description = "A model-airplane flight simulator";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "GPLv2";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://crrcsim.berlios.de/wiki/index.php?n=CRRCsim.DownLoad";
    };
  };
}) x

