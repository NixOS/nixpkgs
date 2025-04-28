{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "15.4.33";
    hash = "sha256-glf0JCsUZD0o3C+3lJ9V2wvamZa8bKySVi/sLo11Mvk=";
    vendorHash = "sha256-J4N2VbiIzfyZJtFvmwW6xZLxB2F9bDRRDfOaWLoHT/4=";
    yarnHash = "sha256-3Ady46LXa3TSSwmWY+GDiS1j5qR5VIuJ5Z+iW5g0SAA=";
    cargoHash = "sha256-aXKrUo+Q9gK09TP9W2PQ3TjDwBtIlUopZL6AJVAiszE=";

    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.100";
      hash = "sha256-3RJzK7mkYFrs7C/WkhW9Rr4LdP5ofb2FdYGz1P7Uxog=";
      cargoHash = "sha256-tD0OY2PounRqsRiFh8Js5nyknQ809ZcHMvCOLrvYHRE=";
    };
  }
)
