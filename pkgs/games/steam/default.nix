{ pkgs, newScope }:

let
  callPackage = newScope self;

  self = rec {
    steamArch = if pkgs.stdenv.system == "x86_64-linux" then "amd64"
                else if pkgs.stdenv.system == "i686-linux" then "i386"
                else throw "Unsupported platform: ${pkgs.stdenv.system}";

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
