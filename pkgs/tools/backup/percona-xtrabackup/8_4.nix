{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "8.4.0-7";
    hash = "sha256-cDMWnk7SOZKnkjf+QVNAh69anr9Q9OSG89nm85tRhao=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
    ];

    extraPostInstall = "";
  }
)
