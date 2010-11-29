x@{builderDefsPackage
  , mesa, SDL, freeglut, SDL_mixer, autoconf, automake, libtool
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    version = "1.3.2";
    name = "gl-117-1.3.2";
    url = "mirror://sourceforge/project/gl-117/gl-117/GL-117%20Source/gl-117-1.3.2-src.tar.bz2";
    hash = "1yvg1rp1yijv0b45cz085b29x5x0g5fkm654xdv5qwh2l6803gb4";
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
    description = "An air combat simulator";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
}) x

