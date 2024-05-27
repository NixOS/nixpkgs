{ callPackage, ... }@args:
callPackage ../generic.nix ({
  version = "14.3.20";
  hash = "sha256-oGN3t0xt7z3+U7wlhnJu4B8cSSMwONdiHZkv8UY7lkA=";
  vendorHash = "sha256-MAUSLtl6eoLBv/iQBMIxDYgw9rlWtHG7kS9wA2iudI8=";
  yarnHash = "sha256-c5ItZpq9Wp+kE9gw2WQdm5gTvBKA9I+nHAX/pT4Hqhs=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-U52FVuqo2DH/7f0cQ1qcb1GbFZ97yxExVFMX5cs0zw4=";
    };
  };
  extPatches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ../tsh_14.patch
  ];
} // builtins.removeAttrs args [ "callPackage" ])
