{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "12.4.7";
  hash = "sha256-Ut+IOLEfRNWmI0G4CPm76SEvhYdAbwtHDSsc+tcGDqA=";
  vendorHash = "sha256-GZmMjIyYNQ6dr8jvB9TjFjnK5iY5FFH/54Qhfp1/ZYY=";
  yarnHash = "sha256-bcozPAIWUWSiANEd98veBtWMvf1EfE6CCBxZhCHOQ7k=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-n4x4w7GZULxqaR109das12+ZGU0xvY3wGOTWngcwe4M=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
