{ lib, newScope, kodi }:

with lib;

let self = rec {

  addonDir = "/share/kodi/addons";
  rel = "Matrix";

  callPackage = newScope self;

  inherit kodi;

  # Convert derivation to a kodi module. Stolen from ../../../top-level/python-packages.nix
  toKodiAddon = drv: drv.overrideAttrs (oldAttrs: {
    # Use passthru in order to prevent rebuilds when possible.
    passthru = (oldAttrs.passthru or {}) // {
      kodiAddonFor = kodi;
      requiredKodiAddons = requiredKodiAddons drv.propagatedBuildInputs;
    };
  });

  # Check whether a derivation provides a Kodi addon.
  hasKodiAddon = drv: drv ? kodiAddonFor && drv.kodiAddonFor == kodi;

  # Get list of required Kodi addons given a list of derivations.
  requiredKodiAddons = drvs:
    let
      modules = filter hasKodiAddon drvs;
    in
      unique (modules ++ concatLists (catAttrs "requiredKodiAddons" modules));

  # package builders

  buildKodiAddon = callPackage ../applications/video/kodi/build-kodi-addon.nix { };

  buildKodiBinaryAddon = callPackage ../applications/video/kodi/build-kodi-binary-addon.nix { };

  # regular packages

  kodi-platform = callPackage ../applications/video/kodi-packages/kodi-platform { };

  # addon packages

  controllers = {
    default = callPackage ../applications/video/kodi-packages/controllers { controller = "default"; };

    dreamcast = callPackage ../applications/video/kodi-packages/controllers { controller = "dreamcast"; };

    gba = callPackage ../applications/video/kodi-packages/controllers { controller = "gba"; };

    genesis = callPackage ../applications/video/kodi-packages/controllers { controller = "genesis"; };

    mouse = callPackage ../applications/video/kodi-packages/controllers { controller = "mouse"; };

    n64 = callPackage ../applications/video/kodi-packages/controllers { controller = "n64"; };

    nes = callPackage ../applications/video/kodi-packages/controllers { controller = "nes"; };

    ps = callPackage ../applications/video/kodi-packages/controllers { controller = "ps"; };

    snes = callPackage ../applications/video/kodi-packages/controllers { controller = "snes"; };
  };

  joystick = callPackage ../applications/video/kodi-packages/joystick { };

  svtplay = callPackage ../applications/video/kodi-packages/svtplay { };

  steam-controller = callPackage ../applications/video/kodi-packages/steam-controller { };

  steam-launcher = callPackage ../applications/video/kodi-packages/steam-launcher { };

  pdfreader = callPackage ../applications/video/kodi-packages/pdfreader { };

  pvr-hts = callPackage ../applications/video/kodi-packages/pvr-hts { };

  pvr-hdhomerun = callPackage ../applications/video/kodi-packages/pvr-hdhomerun { };

  pvr-iptvsimple = callPackage ../applications/video/kodi-packages/pvr-iptvsimple { };

  osmc-skin = callPackage ../applications/video/kodi-packages/osmc-skin { };

  inputstream-adaptive = callPackage ../applications/video/kodi-packages/inputstream-adaptive { };

  vfs-sftp = callPackage ../applications/video/kodi-packages/vfs-sftp { };

  vfs-libarchive = callPackage ../applications/video/kodi-packages/vfs-libarchive { };

}; in self
