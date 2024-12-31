{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "8.4.0-1";
    hash = "sha256-2tWRRYH0P0HZsWTxeuvDeVWvDwqjjdv6J7YiZwoTKtM=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
    ];

    extraPostInstall = '''';
  }
)
