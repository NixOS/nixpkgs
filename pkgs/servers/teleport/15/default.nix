{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (args // {
  version = "15.1.3";
  hash = "sha256-aK/kDiFQzmnmUc4Msq4evUOaHui4EXbTXGVSkh8UrRc=";
  vendorHash = "sha256-SUGy5nSTa4DdvGCV+4tqREi6zbGRSVh8x/iSbb9li8k=";
  yarnHash = "sha256-zPsy1sl5aByrbhd2Crz4GbULPNbEe44XV47tLigTi+Q=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "boring-4.4.0" = "sha256-4wdl2kIA5oHQ0H6IddKQ+B5kRwrTeMbKe1+tAYZt2uw=";
      "ironrdp-async-0.1.0" = "sha256-0p0A3OBsWryUyhsefqrrkUvPOzSMQ2q4DirE4bZNvIw=";
      "sspi-0.10.1" = "sha256-fkclC/plTh2d8zcmqthYmr5yXqbPTeFxI1VuaPX5vxk=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh_14.patch
  ];

  # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
  wasm-bindgen-cli = wasm-bindgen-cli.override {
    version = "0.2.91";
    hash = "sha256-f/RK6s12ItqKJWJlA2WtOXtwX4Y0qa8bq/JHlLTAS3c=";
    cargoHash = "sha256-3vxVI0BhNz/9m59b+P2YEIrwGwlp7K3pyPKt4VqQuHE=";
  };
})
