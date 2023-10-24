{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "13.4.3";
  hash = "sha256-x8G94jKycK3nYwqDA5RPc63GHIk9y4pHfSwSBqGBINk=";
  vendorHash = "sha256-Pb3eO9zqLgTD7otM7yGRWicQjvpIXg7xKV8Oc4yh8PA=";
  yarnHash = "sha256-GnoiLqzqGV0UZm5zePCDBUUX63NTIIo1dcxtiWQDPqc=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-n4x4w7GZULxqaR109das12+ZGU0xvY3wGOTWngcwe4M=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh.patch
    # https://github.com/NixOS/nixpkgs/issues/132652
    ../test.patch
  ];
} // builtins.removeAttrs args [ "callPackage" ])
