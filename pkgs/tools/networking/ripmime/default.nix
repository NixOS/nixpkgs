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
    version="1.4.0.9";
    name="${baseName}-${version}";
    url="http://www.pldaniels.com/${baseName}/${name}.tar.gz";
    hash="15c48n8n8qavdigw5qycnwp6gys9dv3mgk18ylf5hd4491nnnrhz";
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
    ensureDir "$out/bin" "$out/man/man1"
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

