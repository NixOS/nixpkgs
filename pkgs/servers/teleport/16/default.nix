{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "16.5.3";
    hash = "sha256-yaHy75oS+HuO++qHEDaGByz11vwAqfaDT9qb94iKs3Y=";
    vendorHash = "sha256-pHAiJ080lyWtb7xbwSeD9g8JlyXZyqtZC2IpsUJ7YaY=";
    pnpmHash = "sha256-JQca2eFxcKJDHIaheJBg93ivZU95UWMRgbcK7QE4R10=";
    cargoHash = "sha256-04zykCcVTptEPGy35MIWG+tROKFzEepLBmn04mSbt7I=";

    # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.95";
      hash = "sha256-prMIreQeAcbJ8/g3+pMp1Wp9H5u+xLqxRxL+34hICss=";
      cargoHash = "sha256-6iMebkD7FQvixlmghGGIvpdGwFNLfnUcFke/Rg8nPK4=";
    };
  }
)
