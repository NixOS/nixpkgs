{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "11.3.10";
  hash = "sha256-h7G+VPVG+swBo0VHDIQiCDPhsK7MHfkF8/Bagh/KzCg=";
  vendorHash = "sha256-GB024L8c8YRNUySZEPB5HEXss1wcT1gUxM4wUoB4zpQ=";
  yarnHash = "sha256-6qaXHFMhlAhDo6drjUfvgQHgpMbeO8+Y1MZXVCHfelE=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-GJfUyiYQwcDTMqt+iik3mFI0f6mu13RJ2XuoDzlg9sU=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
