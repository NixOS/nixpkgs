{ stdenv
, callPackage
, rocmUpdateScript
, llvm
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  nameSuffix = "-stage1";
  buildMan = false; # No man pages to build
  targetName = "lld";
  targetDir = targetName;
  extraBuildInputs = [ llvm ];
  checkTargets = [ "check-${targetName}" ];
}
