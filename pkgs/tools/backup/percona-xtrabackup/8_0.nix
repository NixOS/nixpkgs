{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "8.0.35-34";
    hash = "sha256-DqjDBLSQqlWazWJjdb+n7RwqSe/OMlZI2ca/JNTX2W8=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
      ./abi-check.patch
    ];
  }
)
