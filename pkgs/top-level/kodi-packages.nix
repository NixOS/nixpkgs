{ lib, newScope, kodi, libretro }:

with lib;

let
  inherit (libretro) genesis-plus-gx snes9x;
in

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

  # package update scripts

  addonUpdateScript = callPackage ../applications/video/kodi-packages/addon-update-script { };

  # package builders

  buildKodiAddon = callPackage ../applications/video/kodi/build-kodi-addon.nix { };

  buildKodiBinaryAddon = callPackage ../applications/video/kodi/build-kodi-binary-addon.nix { };

  # regular packages

  kodi-platform = callPackage ../applications/video/kodi-packages/kodi-platform { };

  # addon packages

  a4ksubtitles = callPackage ../applications/video/kodi-packages/a4ksubtitles { };

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

  libretro = callPackage ../applications/video/kodi-packages/libretro { };

  libretro-genplus = callPackage ../applications/video/kodi-packages/libretro-genplus { inherit genesis-plus-gx; };

  libretro-snes9x = callPackage ../applications/video/kodi-packages/libretro-snes9x { inherit snes9x; };

  jellyfin = callPackage ../applications/video/kodi-packages/jellyfin { };

  joystick = callPackage ../applications/video/kodi-packages/joystick { };

  keymap = callPackage ../applications/video/kodi-packages/keymap { };

  netflix = callPackage ../applications/video/kodi-packages/netflix { };

  svtplay = callPackage ../applications/video/kodi-packages/svtplay { };

  steam-controller = callPackage ../applications/video/kodi-packages/steam-controller { };

  steam-launcher = callPackage ../applications/video/kodi-packages/steam-launcher { };

  steam-library = callPackage ../applications/video/kodi-packages/steam-library { };

  pdfreader = callPackage ../applications/video/kodi-packages/pdfreader { };

  pvr-hts = callPackage ../applications/video/kodi-packages/pvr-hts { };

  pvr-hdhomerun = callPackage ../applications/video/kodi-packages/pvr-hdhomerun { };

  pvr-iptvsimple = callPackage ../applications/video/kodi-packages/pvr-iptvsimple { };

  osmc-skin = callPackage ../applications/video/kodi-packages/osmc-skin { };

  vfs-sftp = callPackage ../applications/video/kodi-packages/vfs-sftp { };

  vfs-libarchive = callPackage ../applications/video/kodi-packages/vfs-libarchive { };

  youtube = callPackage ../applications/video/kodi-packages/youtube { };

  # addon packages (dependencies)

  certifi = callPackage ../applications/video/kodi-packages/certifi { };

  chardet = callPackage ../applications/video/kodi-packages/chardet { };

  dateutil = callPackage ../applications/video/kodi-packages/dateutil { };

  defusedxml = callPackage ../applications/video/kodi-packages/defusedxml { };

  idna = callPackage ../applications/video/kodi-packages/idna { };

  inputstream-adaptive = callPackage ../applications/video/kodi-packages/inputstream-adaptive { };

  inputstream-ffmpegdirect = callPackage ../applications/video/kodi-packages/inputstream-ffmpegdirect { };

  inputstream-rtmp = callPackage ../applications/video/kodi-packages/inputstream-rtmp { };

  inputstreamhelper = callPackage ../applications/video/kodi-packages/inputstreamhelper { };

  kodi-six = callPackage ../applications/video/kodi-packages/kodi-six { };

  myconnpy = callPackage ../applications/video/kodi-packages/myconnpy { };

  requests = callPackage ../applications/video/kodi-packages/requests { };

  requests-cache = callPackage ../applications/video/kodi-packages/requests-cache { };

  routing = callPackage ../applications/video/kodi-packages/routing { };

  signals = callPackage ../applications/video/kodi-packages/signals { };

  six = callPackage ../applications/video/kodi-packages/six { };

  urllib3 = callPackage ../applications/video/kodi-packages/urllib3 { };

  websocket = callPackage ../applications/video/kodi-packages/websocket { };

}; in self
