{ wxGTK, stdenv, newScope }:
let
  callPackage = newScope self;

  self = {
    zeroad-unwrapped = callPackage ./game.nix { inherit wxGTK stdenv; };

    zeroad-data = callPackage ./data.nix { inherit stdenv; };

    zeroad = callPackage ./wrapper.nix { };
  };

in
self
