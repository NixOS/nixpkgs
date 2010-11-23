x@{builderDefsPackage
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="untie";
    version="0.3";
    name="${baseName}-${version}";
    url="http://guichaz.free.fr/${baseName}/files/${name}.tar.bz2";
    hash="154c3550af3d3513022a15381bbc2693f5dd7789bf0a4320635991b8f6b3648c";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["doMakeInstall"];
  makeFlags=["PREFIX=$out"];
      
  meta = {
    description = "A tool to run processes untied from some of the namespaces";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://guichaz.free.fr/untie";
    };
  };
}) x

