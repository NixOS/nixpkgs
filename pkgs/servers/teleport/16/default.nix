{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (args // {
  version = "16.4.8";
  hash = "sha256-izOmea4FP93OvGWi/JlLUZJ9e38d4AfhvusVHj0MWVU=";
  vendorHash = "sha256-xA8Pbf6D2DKU8wztU+pCh3fizIfBVp9wc1zzAg48YcY=";
  pnpmHash = "sha256-+/5dgjxevJwos35txvu+R53FMp3Pp9yxv8YFCuBaNCU=";
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
