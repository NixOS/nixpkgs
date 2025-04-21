{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "15.4.30";
    hash = "sha256-qLGlhCDfIPVJfKI37Wv2XNl5tdloq48wJu8V/ww0yHc=";
    vendorHash = "sha256-aM7VYauCC6zytFELKNyUa30H17ErFmBkyEr+eDoF92g=";
    yarnHash = "sha256-63JX0rAMyZA58CdaqHlTXlL7npvKcYnhVIh1NaJEmBk=";
    cargoHash = "sha256-2lIhtIWl26xoH7XxhPEmG/2FpfwgTC7kmahCim1W4To=";

    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.100";
      hash = "sha256-3RJzK7mkYFrs7C/WkhW9Rr4LdP5ofb2FdYGz1P7Uxog=";
      cargoHash = "sha256-tD0OY2PounRqsRiFh8Js5nyknQ809ZcHMvCOLrvYHRE=";
    };
  }
)
