x@{builderDefsPackage
  , fetchgit, ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["fetchgit"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    version="git-head-${rev}";
    baseName="netboot";
    rev="19a955cd87b399a5b56";
    name="${baseName}-git-head";
    url="git://github.com/ITikhonov/netboot.git";
    hash="7610c734dc46183439c161d327e7ef6a3d5bc07b5173850b92f71ec047b109d6";
  };
in
rec {
  srcDrv = a.fetchgit {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    rev = sourceInfo.rev;
  };

  src=srcDrv + "/";

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doBuild" "doDeploy"];

  doBuild = a.fullDepEntry ''
    gcc netboot.c -o netboot
  '' ["doUnpack" "addInputs"];

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out/bin"
    cp netboot "$out/bin"
  '' ["defEnsureDir" "minInit"];
      
  meta = {
    description = "Mini PXE server";
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
      downloadPage = "https://github.com/ITikhonov/netboot";
    };
  };
}) x

