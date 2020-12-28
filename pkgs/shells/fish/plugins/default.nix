{ lib, newScope }:

lib.makeScope newScope (self: with self; {

  buildFishPlugin = callPackage ./build-fish-plugin.nix { };

  fishtape = callPackage ./fishtape.nix { };

  pure = callPackage ./pure.nix { };

})
