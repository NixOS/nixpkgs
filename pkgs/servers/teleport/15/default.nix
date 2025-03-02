{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "15.4.26";
    hash = "sha256-LxMwCI/8otH32bRJvz9p1zWw4QzF/wrqeboZ6B3aw9o=";
    vendorHash = "sha256-VG9b1M3zdtRXY3eCFC7izejSSs4nTjtR9/wOc36PFnA=";
    yarnHash = "sha256-kmjY7KQfSzmlNS7ZK25YItZct/Tg7CWKfoRfubFBGlY=";
    cargoHash = "sha256-IQi11Hpavj4pImwjxU6uoHQ+vjwc/++NuWXREcIKH3s=";

    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.92";
      hash = "sha256-1VwY8vQy7soKEgbki4LD+v259751kKxSxmo/gqE6yV0=";
      cargoHash = "sha256-aACJ+lYNEU8FFBs158G1/JG8sc6Rq080PeKCMnwdpH0=";
    };
  }
)
