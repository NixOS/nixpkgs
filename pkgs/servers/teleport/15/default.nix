{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "15.4.29";
    hash = "sha256-FL7u7icwTS8V7ZodKjN/9vRTzXgJ0MCRgAz23eA+kfA=";
    vendorHash = "sha256-LL18GI5w9kJdBJf2al9rK3dBwib2mLG/deZgSsmZv0U=";
    yarnHash = "sha256-63JX0rAMyZA58CdaqHlTXlL7npvKcYnhVIh1NaJEmBk=";
    cargoHash = "sha256-2lIhtIWl26xoH7XxhPEmG/2FpfwgTC7kmahCim1W4To=";

    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.100";
      hash = "sha256-3RJzK7mkYFrs7C/WkhW9Rr4LdP5ofb2FdYGz1P7Uxog=";
      cargoHash = "sha256-tD0OY2PounRqsRiFh8Js5nyknQ809ZcHMvCOLrvYHRE=";
    };
  }
)
