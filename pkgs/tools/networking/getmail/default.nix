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
    baseName="getmail";
    version="4.20.0";
    name="${baseName}-${version}";
    url="http://pyropus.ca/software/${baseName}/old-versions/${name}.tar.gz";
    hash="17cpyra61virk1d223w8pdwhv2qzhbwdbnrr1ab1znf4cv9m3knn";
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
  phaseNames = ["installPythonPackage" "patchShebangs" "wrapBinContentsPython"];
  patchShebangs = (a.doPatchShebangs "$out/bin");
      
  meta = {
    description = "A program for retrieval of mail";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://pyropus.ca/software/getmail/";
    };
  };
}) x

