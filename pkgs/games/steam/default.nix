{ pkgs, newScope }:

let
  callPackage = newScope self;

  self = rec {
    steam-runtime = callPackage ./runtime.nix { };
    steam-runtime-wrapped = callPackage ./runtime-wrapped.nix { };
    steam = callPackage ./steam.nix { };
    steam-chrootenv = callPackage ./chrootenv.nix { };
  };

in self
