{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "13.4.26";
  hash = "sha256-vtOig4uIyAGC6yraiqLeJZ3X8arHRGc2AAaopgQLCHo=";
  vendorHash = "sha256-akfdL687QyygPK2yBKRumgfHmkHv0RZBCIEOtVlV32A=";
  yarnHash = "sha256-Os8T4p5/QzZJAvLqJwKgB4XiLg/TYdlXpunStKAc/mk=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-U52FVuqo2DH/7f0cQ1qcb1GbFZ97yxExVFMX5cs0zw4=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh.patch
  ];
} // builtins.removeAttrs args [ "callPackage" ])
