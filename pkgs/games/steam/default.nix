{ pkgs, newScope }:

let
  callPackage = newScope self;

  self = rec {
    steam-runtime = callPackage ./runtime.nix { };
    steam-runtime-wrapped = callPackage ./runtime-wrapped.nix { };
    steam = callPackage ./steam.nix { };
    steam-fonts = callPackage ./fonts.nix { };
    steam-chrootenv = callPackage ./chrootenv.nix {
      steam-runtime-i686 =
        if pkgs.system == "x86_64-linux"
        then pkgs.pkgsi686Linux.steamPackages.steam-runtime
        else null;
    };
  };

in self
