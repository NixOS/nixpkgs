{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "16.5.9";
    hash = "sha256-lIWJV3AQ+XWApfjtdUL8ZlHAXCyvwVAGsZjjvXul36I=";
    vendorHash = "sha256-DdVBtMwz0AIGCYj/QLczG8GPP9mqKrdF+M0NqmM6J0I=";
    pnpmHash = "sha256-JQca2eFxcKJDHIaheJBg93ivZU95UWMRgbcK7QE4R10=";
    cargoHash = "sha256-04zykCcVTptEPGy35MIWG+tROKFzEepLBmn04mSbt7I";

    # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.95";
      hash = "sha256-prMIreQeAcbJ8/g3+pMp1Wp9H5u+xLqxRxL+34hICss=";
      cargoHash = "sha256-6iMebkD7FQvixlmghGGIvpdGwFNLfnUcFke/Rg8nPK4=";
    };
  }
)
