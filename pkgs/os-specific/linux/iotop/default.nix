x@{builderDefsPackage
  , python, makeWrapper
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="iotop";
    version="0.4.1";
    name="${baseName}-${version}";
    url="http://guichaz.free.fr/${baseName}/files/${name}.tar.bz2";
    hash="1dfvw3khr2rvqllvs9wad9ca3ld4i7szqf0ibq87rn36ickrf3ll";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["installPythonPackage" "wrapBinContentsPython"];
      
  meta = {
    description = "A tool to find out the processes doing the most IO";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://guichaz.free.fr/iotop/";
    };
  };
}) x

