x@{builderDefsPackage
  , ncurses
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="wavemon";
    version = "0.7.6";
    name="${baseName}-${version}";
    url="http://eden-feed.erg.abdn.ac.uk/wavemon/stable-releases/${name}.tar.bz2";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "18cwlzgmwzy7z9dfr6lwd8kmkv0pqiihizm4gi0kkm52bzz6836y";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "WiFi state monitor";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2Plus;
    downloadPage = "http://eden-feed.erg.abdn.ac.uk/wavemon/";
    inherit version;
    updateWalker = true;
  };
}) x

