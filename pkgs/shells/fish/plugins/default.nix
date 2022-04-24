{ lib, newScope }:

lib.makeScope newScope (self: with self; {

  buildFishPlugin = callPackage ./build-fish-plugin.nix { };

  clownfish = callPackage ./clownfish.nix { };

  done = callPackage ./done.nix { };

  # Fishtape 2.x and 3.x aren't compatible,
  # but both versions are used in the tests of different other plugins.
  fishtape = callPackage ./fishtape.nix { };
  fishtape_3 = callPackage ./fishtape_3.nix { };

  foreign-env = callPackage ./foreign-env { };

  forgit = callPackage ./forgit.nix { };

  fzf-fish = callPackage ./fzf-fish.nix { };

  hydro = callPackage ./hydro.nix { };

  pisces = callPackage ./pisces.nix { };

  pure = callPackage ./pure.nix { };

})
