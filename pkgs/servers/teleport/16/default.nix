{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "16.4.18";
    hash = "sha256-DpbRfWVsfGpIANs6LMtIPtgsCEt5UMoNBpqelMQF+7s=";
    vendorHash = "sha256-H7EIt9HImdjSQMCv0Jr4mx3woMA6ZSR7KMpQbKvggZU=";
    pnpmHash = "sha256-LHdX7Vo4neaN+SNrh/De3n/0mR6ZgGvJzNKcxOOHpZA=";
    cargoHash = "sha256-NASNBk4QVoqe2cz4l94aXo6pUtF8Qxwb61XRI/ErjTs=";

    # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.95";
      hash = "sha256-prMIreQeAcbJ8/g3+pMp1Wp9H5u+xLqxRxL+34hICss=";
      cargoHash = "sha256-6iMebkD7FQvixlmghGGIvpdGwFNLfnUcFke/Rg8nPK4=";
    };
  }
)
