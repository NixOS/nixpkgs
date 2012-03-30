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
    baseName="ripmime";
    version="1.4.0.10";
    name="${baseName}-${version}";
    url="http://www.pldaniels.com/${baseName}/${name}.tar.gz";
    hash="0sj06ibmlzy34n8v0mnlq2gwidy7n2aqcwgjh0xssz3vi941aqc9";
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
  phaseNames = ["fixTarget" "doMakeInstall"];
  fixTarget = a.fullDepEntry (''
    sed -i Makefile -e "s@LOCATION=.*@LOCATION=$out@"
    mkdir -p "$out/bin" "$out/man/man1"
  '') ["doUnpack" "minInit" "defEnsureDir"];
      
  meta = {
    description = "Attachment extractor for MIME messages";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.pldaniels.com/ripmime/";
    };
  };
}) x

