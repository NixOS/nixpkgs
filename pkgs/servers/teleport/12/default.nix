{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "12.4.32";
  hash = "sha256-dYriqQwrc3tfLv+/G/W8n+4cLbPUq7lq1/kGH/GIsHs=";
  vendorHash = "sha256-R7gWdUIrc7VLe+9/En47FI3G9x2V1VGUVTrT/kmA9c4=";
  yarnHash = "sha256-Sr9T2TmrysMQs6A00rHU1IZjslu8jyYkVnYE6AmBmLA=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-4NbAsEmyUdmBcHuzx+SLQCGKICC4V4FX4GTK2SzyHC0=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh.patch
  ];
} // builtins.removeAttrs args [ "callPackage" ])
