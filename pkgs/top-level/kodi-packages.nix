{ lib, newScope, kodi, libretro }:

with lib;

let
  inherit (libretro) genesis-plus-gx mgba snes9x;
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

  addonUpdateScript = callPackage ../applications/video/kodi/addons/addon-update-script { };

  # package builders

  buildKodiAddon = callPackage ../applications/video/kodi/build-kodi-addon.nix { };

  buildKodiBinaryAddon = callPackage ../applications/video/kodi/build-kodi-binary-addon.nix { };

  # regular packages

  kodi-platform = callPackage ../applications/video/kodi/addons/kodi-platform { };

  # addon packages

  a4ksubtitles = callPackage ../applications/video/kodi/addons/a4ksubtitles { };

  controllers = {
    default = callPackage ../applications/video/kodi/addons/controllers { controller = "default"; };

    dreamcast = callPackage ../applications/video/kodi/addons/controllers { controller = "dreamcast"; };

    gba = callPackage ../applications/video/kodi/addons/controllers { controller = "gba"; };

    genesis = callPackage ../applications/video/kodi/addons/controllers { controller = "genesis"; };

    mouse = callPackage ../applications/video/kodi/addons/controllers { controller = "mouse"; };

    n64 = callPackage ../applications/video/kodi/addons/controllers { controller = "n64"; };

    nes = callPackage ../applications/video/kodi/addons/controllers { controller = "nes"; };

    ps = callPackage ../applications/video/kodi/addons/controllers { controller = "ps"; };

    snes = callPackage ../applications/video/kodi/addons/controllers { controller = "snes"; };
  };

  iagl = callPackage ../applications/video/kodi/addons/iagl { };

  libretro = callPackage ../applications/video/kodi/addons/libretro { };

  libretro-genplus = callPackage ../applications/video/kodi/addons/libretro-genplus { inherit genesis-plus-gx; };

  libretro-mgba = callPackage ../applications/video/kodi/addons/libretro-mgba { inherit mgba; };

  libretro-snes9x = callPackage ../applications/video/kodi/addons/libretro-snes9x { inherit snes9x; };

  jellyfin = callPackage ../applications/video/kodi/addons/jellyfin { };

  joystick = callPackage ../applications/video/kodi/addons/joystick { };

  keymap = callPackage ../applications/video/kodi/addons/keymap { };

  netflix = callPackage ../applications/video/kodi/addons/netflix { };

  svtplay = callPackage ../applications/video/kodi/addons/svtplay { };

  steam-controller = callPackage ../applications/video/kodi/addons/steam-controller { };

  steam-launcher = callPackage ../applications/video/kodi/addons/steam-launcher { };

  steam-library = callPackage ../applications/video/kodi/addons/steam-library { };

  pdfreader = callPackage ../applications/video/kodi/addons/pdfreader { };

  pvr-hts = callPackage ../applications/video/kodi/addons/pvr-hts { };

  pvr-hdhomerun = callPackage ../applications/video/kodi/addons/pvr-hdhomerun { };

  pvr-iptvsimple = callPackage ../applications/video/kodi/addons/pvr-iptvsimple { };

  osmc-skin = callPackage ../applications/video/kodi/addons/osmc-skin { };

  vfs-sftp = callPackage ../applications/video/kodi/addons/vfs-sftp { };

  vfs-libarchive = callPackage ../applications/video/kodi/addons/vfs-libarchive { };

  youtube = callPackage ../applications/video/kodi/addons/youtube { };

  # addon packages (dependencies)

  archive_tool = callPackage ../applications/video/kodi/addons/archive_tool { };

  certifi = callPackage ../applications/video/kodi/addons/certifi { };

  chardet = callPackage ../applications/video/kodi/addons/chardet { };

  dateutil = callPackage ../applications/video/kodi/addons/dateutil { };

  defusedxml = callPackage ../applications/video/kodi/addons/defusedxml { };

  idna = callPackage ../applications/video/kodi/addons/idna { };

  inputstream-adaptive = callPackage ../applications/video/kodi/addons/inputstream-adaptive { };

  inputstream-ffmpegdirect = callPackage ../applications/video/kodi/addons/inputstream-ffmpegdirect { };

  inputstream-rtmp = callPackage ../applications/video/kodi/addons/inputstream-rtmp { };

  inputstreamhelper = callPackage ../applications/video/kodi/addons/inputstreamhelper { };

  kodi-six = callPackage ../applications/video/kodi/addons/kodi-six { };

  myconnpy = callPackage ../applications/video/kodi/addons/myconnpy { };

  requests = callPackage ../applications/video/kodi/addons/requests { };

  requests-cache = callPackage ../applications/video/kodi/addons/requests-cache { };

  routing = callPackage ../applications/video/kodi/addons/routing { };

  signals = callPackage ../applications/video/kodi/addons/signals { };

  six = callPackage ../applications/video/kodi/addons/six { };

  urllib3 = callPackage ../applications/video/kodi/addons/urllib3 { };

  websocket = callPackage ../applications/video/kodi/addons/websocket { };

}; in self
