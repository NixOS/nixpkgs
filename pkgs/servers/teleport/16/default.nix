{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (args // {
  version = "16.2.0";
  hash = "sha256-3LLoO7SNJfEfDEU7JnAhmAOIdRO+TkgiJKjT8sqzelo=";
  vendorHash = "sha256-iyYfht0aB9Vv2hsaqrieFHXbDhlotKQYfLn4JFqpve8=";
  pnpmHash = "sha256-phDrOSFQsgA+I4PDK9LJasUBXBO8EkVtQIMx9M4v8u0=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
       "boring-4.7.0" = "sha256-ACzw4Bfo6OUrwvi3h21tvx5CpdQaWCEIDkslzjzy9o8=";
       "ironrdp-async-0.1.0" = "sha256-DOwDHavDaEda+JK9M6kbvseoXe2LxJg3MLTY/Nu+PN0=";
     };
  };

  # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
  wasm-bindgen-cli = wasm-bindgen-cli.override {
    version = "0.2.93";
    hash = "sha256-DDdu5mM3gneraM85pAepBXWn3TMofarVR4NbjMdz3r0=";
    cargoHash = "sha256-birrg+XABBHHKJxfTKAMSlmTVYLmnmqMDfRnmG6g/YQ=";
  };
})
