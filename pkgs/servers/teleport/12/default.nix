{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "12.1.5";
  hash = "sha256-bPnXZTe4LB50W2UT/sA+2Or/LJMqcEuPpTTF8ue/2Ak=";
  vendorHash = "sha256-mznhfliYpsJJJSL17Q7WXX0SkIn+Bcb1fzYdLRTRDI0=";
  yarnHash = "sha256-cElFTxolQnJAbpln2aGjlTJr/hbUML4QHeHQ3yrWVqU=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-n4x4w7GZULxqaR109das12+ZGU0xvY3wGOTWngcwe4M=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
