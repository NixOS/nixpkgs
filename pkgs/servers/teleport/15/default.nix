{ wasm-bindgen-cli, ... }@args:
import ../generic.nix (args // {
  version = "15.2.2";
  hash = "sha256-LzJaskFaBtWkodeuT4mDNTs4+6FZj2OI+ZtjogU3KzQ=";
  vendorHash = "sha256-D62Jk6LKdbprvkzAKoQVnEKdGQp5ITJYFf53q6154pU=";
  yarnHash = "sha256-jpcjO1wT6m8J7LNQVeWo1j2G5P+sexrnNF1ipCZ8lCU=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "boring-4.4.0" = "sha256-4wdl2kIA5oHQ0H6IddKQ+B5kRwrTeMbKe1+tAYZt2uw=";
      "ironrdp-async-0.1.0" = "sha256-BKaVPr3O4D7DdwNJUjrU1zB7OwmJZnpJeyuMx+FqKjI=";
      "sspi-0.10.1" = "sha256-fkclC/plTh2d8zcmqthYmr5yXqbPTeFxI1VuaPX5vxk=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh_14.patch
  ];

  # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
  wasm-bindgen-cli = wasm-bindgen-cli.override {
    version = "0.2.91";
    hash = "sha256-f/RK6s12ItqKJWJlA2WtOXtwX4Y0qa8bq/JHlLTAS3c=";
    cargoHash = "sha256-3vxVI0BhNz/9m59b+P2YEIrwGwlp7K3pyPKt4VqQuHE=";
  };
})
