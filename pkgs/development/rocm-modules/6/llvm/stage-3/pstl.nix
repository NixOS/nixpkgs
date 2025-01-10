{
  stdenv,
  callPackage,
  rocmUpdateScript,
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildDocs = false; # No documentation to build
  buildMan = false; # No man pages to build
  buildTests = false; # Too many errors
  targetName = "pstl";
  targetDir = "runtimes";
  targetRuntimes = [ targetName ];
  checkTargets = [ "check-${targetName}" ];
}
