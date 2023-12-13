{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "14.1.1";
  hash = "sha256-xdJBl5imHuo1IP0ja33eaaE4i/sSP3kg/wQwehC1Hao=";
  vendorHash = "sha256-+kCns/xHUfUOW2xBk6CaPZYWe/vcEguz2/4lqaJEbFc=";
  yarnHash = "sha256-fWBMeat1bSIEMSADn8oDVfQtnUBojjy5ZCdVhw8PGMs=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-n4x4w7GZULxqaR109das12+ZGU0xvY3wGOTWngcwe4M=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh_14.patch
  ];
} // builtins.removeAttrs args [ "callPackage" ])
