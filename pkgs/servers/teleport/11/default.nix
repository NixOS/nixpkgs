{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "11.3.25";
  hash = "sha256-KIbRn90BUJp8Uc8GMHuIMMSn5tJQbxzE0ntngx1ELaE=";
  vendorHash = "sha256-hjMv/H4dlinlv3ku7i1km2/b+6uCdbznHtVOMIjDlUc=";
  yarnHash = "sha256-hip0WQVZpx2qfVDmEy4nk4UFYEjX1Xhj8HsIIQ8PF1Y=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-GJfUyiYQwcDTMqt+iik3mFI0f6mu13RJ2XuoDzlg9sU=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh.patch
    # https://github.com/NixOS/nixpkgs/issues/132652
    ../test.patch
  ];
} // builtins.removeAttrs args [ "callPackage" ])
