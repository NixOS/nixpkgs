{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "13.4.5";
  hash = "sha256-uZolRnESFP65Xgvr29laEok2kBbm7G2qY9j8yKRrUdo=";
  vendorHash = "sha256-Bkr6R9P2YTqvTEQkHvVdsRmWp6pv3Qg0WaQ+pERclWc=";
  yarnHash = "sha256-60k4LRHpX4rYXZZ0CC44PqzL3PDu8PadV0kwXatnByI=";
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
