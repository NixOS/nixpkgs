{ newScope }:

let
  callPackage = newScope self;

  self = {
    zeroad-unwrapped = callPackage ./game.nix { };

    zeroad-data = callPackage ./data.nix { };

    zeroad = callPackage ./wrapper.nix { };
  };

in self
