{ callPackage, ... }@args:
callPackage ../generic.nix ({
<<<<<<< HEAD
  version = "12.4.7";
  hash = "sha256-Ut+IOLEfRNWmI0G4CPm76SEvhYdAbwtHDSsc+tcGDqA=";
  vendorHash = "sha256-GZmMjIyYNQ6dr8jvB9TjFjnK5iY5FFH/54Qhfp1/ZYY=";
  yarnHash = "sha256-bcozPAIWUWSiANEd98veBtWMvf1EfE6CCBxZhCHOQ7k=";
=======
  version = "12.1.5";
  hash = "sha256-bPnXZTe4LB50W2UT/sA+2Or/LJMqcEuPpTTF8ue/2Ak=";
  vendorHash = "sha256-mznhfliYpsJJJSL17Q7WXX0SkIn+Bcb1fzYdLRTRDI0=";
  yarnHash = "sha256-cElFTxolQnJAbpln2aGjlTJr/hbUML4QHeHQ3yrWVqU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-n4x4w7GZULxqaR109das12+ZGU0xvY3wGOTWngcwe4M=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
