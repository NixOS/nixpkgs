{ pkgs, newScope }:

let
  callPackage = newScope self;

  self = rec {
    steamArch = if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
                else if pkgs.stdenv.hostPlatform.system == "i686-linux" then "i386"
                else throw "Unsupported platform: ${pkgs.stdenv.hostPlatform.system}";

    steam-runtime = callPackage ./runtime.nix { };
    steam-runtime-wrapped = callPackage ./runtime-wrapped.nix { };
    steam = callPackage ./steam.nix { };
    steam-fonts = callPackage ./fonts.nix { };
    steam-chrootenv = callPackage ./chrootenv.nix {
      glxinfo-i686 = pkgs.pkgsi686Linux.glxinfo;
      steam-runtime-wrapped-i686 =
        if steamArch == "amd64"
        then pkgs.pkgsi686Linux.steamPackages.steam-runtime-wrapped
        else null;
    };
  };

in self
