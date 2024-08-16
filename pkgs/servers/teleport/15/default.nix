{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (args // {
  version = "15.4.11";
  hash = "sha256-vmJ76aRAsbSGXZ2HcuryOlUYrUOPMP6MaI8OjxxyiZ4=";
  vendorHash = "sha256-oJo8Ga6TAUz1xSYiRckzq8zZvgIZFCeEwZbiyyVOdkI=";
  yarnHash = "sha256-5ppgBa5CyQ49FSFhdWDbTcCTdt0vsXAzNTeyG4r7crg=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "boring-4.4.0" = "sha256-4wdl2kIA5oHQ0H6IddKQ+B5kRwrTeMbKe1+tAYZt2uw=";
      "ironrdp-async-0.1.0" = "sha256-nE5O/wRJ3vJqJG5zdYmpVkhx6JC6Yb92pR4EKSWSdkA=";
      "sspi-0.10.1" = "sha256-fkclC/plTh2d8zcmqthYmr5yXqbPTeFxI1VuaPX5vxk=";
    };
  };

  # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
  wasm-bindgen-cli = wasm-bindgen-cli.override {
    version = "0.2.92";
    hash = "sha256-1VwY8vQy7soKEgbki4LD+v259751kKxSxmo/gqE6yV0=";
    cargoHash = "sha256-aACJ+lYNEU8FFBs158G1/JG8sc6Rq080PeKCMnwdpH0=";
  };
})
