{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "14.0.1";
  hash = "sha256-esQwk2PFnk3/REzLr3ExtzEcUs2q4Tn/2KpfFWAx5uU=";
  vendorHash = "sha256-lzwrkW0dHxCHBSJjzNhXgq3Av8Zj8xEn3kfTRtT/q04=";
  yarnHash = "sha256-Y2dVxRyKPLD2xjwr0QqrKHf/4gnMCErmDzievu5zTGg=";
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
