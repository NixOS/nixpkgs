{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "8.0.35-36";
    hash = "sha256-5PCIsQMx5xMdI1CwbcaPWZd8HEd1tsFVSKy6+xTWdSI=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
      ./abi-check.patch
    ];
  }
)
