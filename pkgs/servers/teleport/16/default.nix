{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "16.5.0";
    hash = "sha256-d634UB/YGDdAeBEJcRsRE5gqd31oQX3P4HJ+PoMQUmk=";
    vendorHash = "sha256-0/ZYG8mYv3B0YJ89NJVG7M29/hU2zBtSXmoD32VEqpk=";
    pnpmHash = "sha256-dqCfwMzSnEPQXz1bsroqSihkvw2Kcvyz+A4fpa52LVk=";
    cargoHash = "sha256-NASNBk4QVoqe2cz4l94aXo6pUtF8Qxwb61XRI/ErjTs=";

    # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.95";
      hash = "sha256-prMIreQeAcbJ8/g3+pMp1Wp9H5u+xLqxRxL+34hICss=";
      cargoHash = "sha256-6iMebkD7FQvixlmghGGIvpdGwFNLfnUcFke/Rg8nPK4=";
    };
  }
)
