{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "16.4.16";
    hash = "sha256-0nag5T+qv00uA//N9ZDuCqarCfXYn76Ycxd97FfILpE=";
    vendorHash = "sha256-5fSMbmvnbJ4zQuTBsmN/Ym3syn819hRmxv0aRzDnRFU=";
    pnpmHash = "sha256-OpCUYn69UNs6cplM74oNO4hQ5wiYBbjqGN3bJfbrsqk=";
    cargoHash = "sha256-oavJSszi6uWfUIzD+wRZL3wAFgmPvFwGeNHZexOlup4=";

    # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.95";
      hash = "sha256-prMIreQeAcbJ8/g3+pMp1Wp9H5u+xLqxRxL+34hICss=";
      cargoHash = "sha256-6iMebkD7FQvixlmghGGIvpdGwFNLfnUcFke/Rg8nPK4=";
    };
  }
)
