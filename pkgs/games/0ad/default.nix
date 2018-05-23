{ wxGTK, newScope, darwin }:

let
  callPackage = newScope self;

  self = {
    zeroad-unwrapped = callPackage ./game.nix {
      inherit wxGTK;
      inherit (darwin.apple_sdk.frameworks) CoreServices;
    };

    zeroad-data = callPackage ./data.nix { };

    zeroad = callPackage ./wrapper.nix { };
  };

in self
