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
    baseName="altermime";
    version="0.3.10";
    name="${baseName}-${version}";
    url="http://www.pldaniels.com/${baseName}/${name}.tar.gz";
    hash="0vn3vmbcimv0n14khxr1782m76983zz9sf4j2kz5v86lammxld43";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  patches = map a.fetchurl (import ./debian-patches.nix);

  phaseNames = ["doPatch" "fixTarget" "doMakeInstall"];
  fixTarget = a.fullDepEntry (''
    sed -i Makefile -e "s@/usr/local@$out@"
    mkdir -p "$out/bin"
  '') ["doUnpack" "minInit" "defEnsureDir"];
      
  meta = {
    description = "MIME alteration tool";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.pldaniels.com/altermime/";
    };
  };
}) x

