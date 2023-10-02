{ callPackage
, recurseIntoAttrs
}:

let
  rocmUpdateScript = callPackage ./update.nix { };
in {
  llvm = recurseIntoAttrs (callPackage ./llvm/default.nix { inherit rocmUpdateScript; });
}
