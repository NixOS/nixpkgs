{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "13.4.1";
  hash = "sha256-wgSaek4eq5Jx9SZFenvdRSU1wEtfJHzTz9GdczzUU2w=";
  vendorHash = "sha256-DesT18nV/SxOsKCC+Nt0hgtH7CRtRL0B5FQhE1J148I=";
  yarnHash = "sha256-iyMcP9L6dwBhN8JL9eSVEzsXI2EOjfyxjF9Dm4Gs04s=";
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
