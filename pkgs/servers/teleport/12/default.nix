{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "12.4.22";
  hash = "sha256-UEiS+GiderYTU34GHsQr4G8XrasV5ewmPcdrec4v5B4=";
  vendorHash = "sha256-etutgK/5u+e86kx7ha3x+di9np7Tcr7hpGUMKZxJNT4=";
  yarnHash = "sha256-MBTElkMH5rb33l+AYWH+zguSLQf+ntXpOkHZpjLAx/Q=";
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
