{ config, lib, newScope, kodi, libretro }:

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

  arteplussept = callPackage ../applications/video/kodi/addons/arteplussept { };

  controller-topology-project = callPackage ../applications/video/kodi/addons/controller-topology-project { };

  iagl = callPackage ../applications/video/kodi/addons/iagl { };

  invidious = callPackage ../applications/video/kodi/addons/invidious { };

  libretro = callPackage ../applications/video/kodi/addons/libretro { };

  libretro-genplus = callPackage ../applications/video/kodi/addons/libretro-genplus { inherit genesis-plus-gx; };

  libretro-mgba = callPackage ../applications/video/kodi/addons/libretro-mgba { inherit mgba; };

  libretro-snes9x = callPackage ../applications/video/kodi/addons/libretro-snes9x { inherit snes9x; };

  jellyfin = callPackage ../applications/video/kodi/addons/jellyfin { };

  joystick = callPackage ../applications/video/kodi/addons/joystick { };

  keymap = callPackage ../applications/video/kodi/addons/keymap { };

  netflix = callPackage ../applications/video/kodi/addons/netflix { };

  orftvthek = callPackage ../applications/video/kodi/addons/orftvthek { };

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

  future = callPackage ../applications/video/kodi/addons/future { };

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

  simplejson = callPackage ../applications/video/kodi/addons/simplejson { };

  six = callPackage ../applications/video/kodi/addons/six { };

  urllib3 = callPackage ../applications/video/kodi/addons/urllib3 { };

  websocket = callPackage ../applications/video/kodi/addons/websocket { };

  xbmcswift2 = callPackage ../applications/video/kodi/addons/xbmcswift2 { };

  typing_extensions = callPackage ../applications/video/kodi/addons/typing_extensions { };

  arrow = callPackage ../applications/video/kodi/addons/arrow { };

  trakt-module = callPackage ../applications/video/kodi/addons/trakt-module { };

  trakt = callPackage ../applications/video/kodi/addons/trakt { };
}; in self // lib.optionalAttrs config.allowAliases {
  # deprecated or renamed packages

  controllers = throw "kodi.packages.controllers has been replaced with kodi.packages.controller-topology-project - a package which contains a large number of controller profiles." { };
}
