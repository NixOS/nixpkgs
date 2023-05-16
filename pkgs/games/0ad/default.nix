<<<<<<< HEAD
{ fmt, wxGTK, stdenv, newScope }:
=======
{ wxGTK, stdenv, newScope }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  callPackage = newScope self;

  self = {
<<<<<<< HEAD
    zeroad-unwrapped = callPackage ./game.nix { inherit fmt wxGTK stdenv; };
=======
    zeroad-unwrapped = callPackage ./game.nix { inherit wxGTK stdenv; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    zeroad-data = callPackage ./data.nix { inherit stdenv; };

    zeroad = callPackage ./wrapper.nix { };
  };

in
self
