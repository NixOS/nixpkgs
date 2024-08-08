{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (args // {
  version = "16.1.4";
  hash = "sha256-WgMQzS7nwIwPojcf9HTLajLd0WV+RYEbyp/aWr9XFWc=";
  vendorHash = "sha256-8WN4hVueA2o2bHhhxLGPYxPX+1qky8QHGTRqhEGNh9s=";
  pnpmHash = "sha256-phDrOSFQsgA+I4PDK9LJasUBXBO8EkVtQIMx9M4v8u0=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "boring-4.7.0" = "sha256-ACzw4Bfo6OUrwvi3h21tvx5CpdQaWCEIDkslzjzy9o8=";
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
