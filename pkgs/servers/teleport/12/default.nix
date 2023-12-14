{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "12.4.23";
  hash = "sha256-kCHRBa9rdwfcb98XG/08ZaJmI1NhEiSCoXuH8/3xJlk=";
  vendorHash = "sha256-yOvQQHjtDSLqQZcw2OIOy6CDqwYSgMpL2Rxlk2u//OE=";
  yarnHash = "sha256-beHCg9qUSisYMJ/9eeqWmbc9+V9YGgXBheZSFpbqoPY=";
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
