{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "8.0.35-32";
    hash = "sha256-aNnAlhhzZ6636dzOz4FFDEE4Mb450HGU42cJrM21GdQ=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
      ./abi-check.patch
    ];

    extraPostInstall = ''
      rm -r "$out"/docs
    '';
  }
)
