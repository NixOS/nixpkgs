x@{builderDefsPackage
  , lua5, python
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="bam";
    version="0.4.0";
    name="${baseName}-${version}";
    url="http://github.com/downloads/matricks/bam/${name}.tar.bz2";
    hash="0z90wvyd4nfl7mybdrv9dsd4caaikc6fxw801b72gqi1m9q0c0sn";
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
  phaseNames = ["check" "doDeploy"];

  build = a.fullDepEntry ''
    sh make_unix.sh
  '' ["minInit" "doUnpack" "addInputs"];

  check = a.fullDepEntry ''
    python scripts/test.py
  '' ["build" "addInputs"];

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out/share/bam"
    cp -r docs examples tests  "$out/share/bam"
    mkdir -p "$out/bin"
    cp bam "$out/bin"
  '' ["minInit" "defEnsureDir" "build"];
      
  meta = {
    description = "Yet another build manager";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "free-noncopyleft";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://matricks.github.com/bam/";
    };
  };
}) x

