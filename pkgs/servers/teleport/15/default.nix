{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "15.3.7";
    hash = "sha256-d+lfM1yt0xAWBqAqBCdEFcOHz32VT0EI4LybVbmjW0o=";
    vendorHash = "sha256-pM6wy1tuMmUg8iNfeSmg8dW1cvP7G3fXa3vYuSEEdOc=";
    yarnHash = "sha256-eWrR06FVkFxCrk+Z7BrY4dJjvEnUYzYrhSeD8ir3a08=";
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "boring-4.4.0" = "sha256-4wdl2kIA5oHQ0H6IddKQ+B5kRwrTeMbKe1+tAYZt2uw=";
        "ironrdp-async-0.1.0" = "sha256-NpBzPsvopu5Te6Ljln5rp1Wxc6O6mRB4lLh0JVnN+Xc=";
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
  }
)
