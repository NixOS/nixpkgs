{ callPackage, ...}:

let
  ue5-unwrapped = callPackage ./unwrapped.nix {};
  ue5 = callPackage ./wrapper.nix { inherit ue5-unwrapped; };
in ue5
