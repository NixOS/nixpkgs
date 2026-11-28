{ callPackage, fetchpatch, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "9.7.2-2";
    hash = "sha256-ZswQ8gAtjP55QtCZSa0R9+OUqx3IQMBMBxuqeYB6VNg=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
    ];

    extraPostInstall = "";
  }
)
