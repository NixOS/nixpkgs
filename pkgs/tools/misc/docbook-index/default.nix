{ callPackage }:

(callPackage ./Cargo.nix {
  cratesIO = callPackage ./crates-io.nix {};
}).docbook_index {}
