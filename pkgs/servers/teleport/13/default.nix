{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "13.3.8";
  hash = "sha256-BpEyjhmeJCMln5zxWVzIYWGMxre8OSn7lp+H4lmqm1Y=";
  vendorHash = "sha256-TUFWDd5v/emLqmnBHprW4ytdeKQkULtk7xvPwEOkw0M=";
  yarnHash = "sha256-ydF0OIFeNYMCT+Z5vbL2M/WSs8/Q6t35+YucuSvnFiw=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-n4x4w7GZULxqaR109das12+ZGU0xvY3wGOTWngcwe4M=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
