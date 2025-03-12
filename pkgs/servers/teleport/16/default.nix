{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "16.4.17";
    hash = "sha256-NLWISsh0zoTn849VK5YL2zxp7zuu7xFqLdbP/cPeNFc=";
    vendorHash = "sha256-OoGx3ae69NCY6OFs/Ez4Lc8NVcgxl4bRoicFAVHicdQ=";
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
