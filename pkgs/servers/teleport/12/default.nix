{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "12.4.20";
  hash = "sha256-Qz+JOS4YPj2865Fkj7eVJMdilHMOGbTD179bQ5wHY7A=";
  vendorHash = "sha256-cS8ylLujgp9Is+D2JjoK4yGgWRCVRyRw3NPQAAuE2vY=";
  yarnHash = "sha256-tOdT7X8jM+tl1GZ7lBN2aW8KRiVW/zWK9fZIU7CSHVE=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-n4x4w7GZULxqaR109das12+ZGU0xvY3wGOTWngcwe4M=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh.patch
    # https://github.com/NixOS/nixpkgs/issues/132652
    ../test.patch
  ];
} // builtins.removeAttrs args [ "callPackage" ])
