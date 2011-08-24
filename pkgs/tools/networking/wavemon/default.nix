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
    version="0.7.2";
    name="${baseName}-${version}";
    url="http://eden-feed.erg.abdn.ac.uk/wavemon/stable-releases/${name}.tar.bz2";
    hash="1w1nq082mpjkcj7q6qs80104vki9kddwqv1wch6nmwwh0l72dgma";
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

