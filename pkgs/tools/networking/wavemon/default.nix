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
    version="0.7.5";
    name="${baseName}-${version}";
    url="http://eden-feed.erg.abdn.ac.uk/wavemon/stable-releases/${name}.tar.bz2";
    hash="0b1fx00aar2fsw49a10w5bpiyjpz8h8f4nrlwb1acfw36yi1pfkd";
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
    description = "WiFi state monitor";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://eden-feed.erg.abdn.ac.uk/wavemon/";
    };
  };
}) x

