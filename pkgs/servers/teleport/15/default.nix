{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (
  args
  // {
    version = "15.5.2";
    hash = "sha256-+6+OTQ7G3c4xYhTqJIYuV95xjlBjSw7lnts/7/lXXzM=";
    vendorHash = "sha256-DNyC5duFufWBk0F2mMAMHHTVusCbNKVtZG2UOUQfZMI=";
    yarnHash = "sha256-TOWqpMaZLGhdUaN3r3fGgviKi9BbZHoLcu3d7oLr2gk=";
    cargoHash = "sha256-aXKrUo+Q9gK09TP9W2PQ3TjDwBtIlUopZL6AJVAiszE";

    wasm-bindgen-cli = wasm-bindgen-cli.override {
      version = "0.2.100";
      hash = "sha256-3RJzK7mkYFrs7C/WkhW9Rr4LdP5ofb2FdYGz1P7Uxog=";
      cargoHash = "sha256-tD0OY2PounRqsRiFh8Js5nyknQ809ZcHMvCOLrvYHRE=";
    };
  }
)
