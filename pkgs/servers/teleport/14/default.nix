{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "14.0.3";
  hash = "sha256-X+vekYmuTE7n22SH/z2GWO3wnBsIef1GEjR7WOJpjc8=";
  vendorHash = "sha256-+R6f2HrlN/RLec83YutccDFJW6gq6HXbxoJVtxMgdp8=";
  yarnHash = "sha256-udM4DNaTGiMkqfkllJjmT+Nk6PNbGUzT34ixQOhmScw=";
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
