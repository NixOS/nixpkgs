{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "8.4.0-2";
    hash = "sha256-ClW/B175z/sxF/MT9iHW1Wtr0ere63tIgUpcMp1IfTs=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
    ];

    extraPostInstall = '''';
  }
)
