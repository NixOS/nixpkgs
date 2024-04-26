args:
import ../generic.nix (args // {
  version = "14.3.0";
  hash = "sha256-yTbJeHCmPlelq7BrZQRY3XyNQiovV7NQ1tNh2NfYGbk=";
  vendorHash = "sha256-lHsgSbY1nqQminU67QgV6FbHXNlv5tCMv2oVq48S33M=";
  yarnHash = "sha256-m934P+KygGiCzr5fDsNTlmZ1T9JxA6P8zTimocQyVi0=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-4NbAsEmyUdmBcHuzx+SLQCGKICC4V4FX4GTK2SzyHC0=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh_14.patch
  ];
})
