{
  config,
  lib,
  newScope,
  kodi,
  libretro,
}:

let
  inherit (lib)
    catAttrs
    concatLists
    filter
    optionalAttrs
    unique
    ;

  inherit (libretro)
    fuse
    genesis-plus-gx
    gw
    mgba
    nestopia
    snes9x
    twenty-fortyeight
    ;

  callPackage = newScope self;

  # Check whether a derivation provides a Kodi addon.
  hasKodiAddon = drv: drv ? kodiAddonFor && drv.kodiAddonFor == kodi;

  # Get list of required Kodi addons given a list of derivations.
  requiredKodiAddons =
    drvs:
    let
      modules = filter hasKodiAddon drvs;
    in
    unique (modules ++ concatLists (catAttrs "requiredKodiAddons" modules));

  self = {
    addonDir = "/share/kodi/addons";

    rel = kodi.kodiReleaseName;

    inherit
      callPackage
      kodi
      hasKodiAddon
      requiredKodiAddons
      ;

    # Convert derivation to a kodi module. Stolen from ../../../top-level/python-packages.nix
    toKodiAddon =
      drv:
      drv.overrideAttrs (oldAttrs: {
        # Use passthru in order to prevent rebuilds when possible.
        passthru = (oldAttrs.passthru or { }) // {
          kodiAddonFor = kodi;
          requiredKodiAddons = requiredKodiAddons drv.propagatedBuildInputs;
        };
      });

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

    bluetooth-manager = callPackage ../applications/video/kodi/addons/bluetooth-manager { };

    controller-topology-project =
      callPackage ../applications/video/kodi/addons/controller-topology-project
        { };

    formula1 = callPackage ../applications/video/kodi/addons/formula1 { };

    iagl = callPackage ../applications/video/kodi/addons/iagl { };

    invidious = callPackage ../applications/video/kodi/addons/invidious { };

    libretro = callPackage ../applications/video/kodi/addons/libretro { };

    libretro-2048 = callPackage ../applications/video/kodi/addons/libretro-2048 {
      inherit twenty-fortyeight;
    };

    libretro-fuse = callPackage ../applications/video/kodi/addons/libretro-fuse { inherit fuse; };

    libretro-genplus = callPackage ../applications/video/kodi/addons/libretro-genplus {
      inherit genesis-plus-gx;
    };

    libretro-gw = callPackage ../applications/video/kodi/addons/libretro-gw { inherit gw; };

    libretro-mgba = callPackage ../applications/video/kodi/addons/libretro-mgba { inherit mgba; };

    libretro-nestopia = callPackage ../applications/video/kodi/addons/libretro-nestopia {
      inherit nestopia;
    };

    libretro-snes9x = callPackage ../applications/video/kodi/addons/libretro-snes9x { inherit snes9x; };

    jellycon = callPackage ../applications/video/kodi/addons/jellycon { };

    jellyfin = callPackage ../applications/video/kodi/addons/jellyfin { };

    joystick = callPackage ../applications/video/kodi/addons/joystick { };

    keymap = callPackage ../applications/video/kodi/addons/keymap { };

    mediacccde = callPackage ../applications/video/kodi/addons/mediacccde { };

    mediathekview = callPackage ../applications/video/kodi/addons/mediathekview { };

    netflix = callPackage ../applications/video/kodi/addons/netflix { };

    plex-for-kodi = callPackage ../applications/video/kodi/addons/plex-for-kodi { };

    orftvthek = callPackage ../applications/video/kodi/addons/orftvthek { };

    radioparadise = callPackage ../applications/video/kodi/addons/radioparadise { };

    raiplay = callPackage ../applications/video/kodi/addons/raiplay { };

    robotocjksc = callPackage ../applications/video/kodi/addons/robotocjksc { };

    screensaver-asteroids = callPackage ../applications/video/kodi/addons/screensaver-asteroids { };

    skyvideoitalia = callPackage ../applications/video/kodi/addons/skyvideoitalia { };

    steam-controller = callPackage ../applications/video/kodi/addons/steam-controller { };

    steam-launcher = callPackage ../applications/video/kodi/addons/steam-launcher { };

    steam-library = callPackage ../applications/video/kodi/addons/steam-library { };

    somafm = callPackage ../applications/video/kodi/addons/somafm { };

    pdfreader = callPackage ../applications/video/kodi/addons/pdfreader { };

    pvr-hts = callPackage ../applications/video/kodi/addons/pvr-hts { };

    pvr-hdhomerun = callPackage ../applications/video/kodi/addons/pvr-hdhomerun { };

    pvr-iptvsimple = callPackage ../applications/video/kodi/addons/pvr-iptvsimple { };

    pvr-vdr-vnsi = callPackage ../applications/video/kodi/addons/pvr-vdr-vnsi { };

    osmc-skin = callPackage ../applications/video/kodi/addons/osmc-skin { };

    texturemaker = callPackage ../applications/video/kodi/addons/texturemaker { };

    upnext = callPackage ../applications/video/kodi/addons/upnext { };

    vfs-libarchive = callPackage ../applications/video/kodi/addons/vfs-libarchive { };

    vfs-rar = callPackage ../applications/video/kodi/addons/vfs-rar { };

    vfs-sftp = callPackage ../applications/video/kodi/addons/vfs-sftp { };

    visualization-fishbmc = callPackage ../applications/video/kodi/addons/visualization-fishbmc { };

    visualization-goom = callPackage ../applications/video/kodi/addons/visualization-goom { };

    visualization-matrix = callPackage ../applications/video/kodi/addons/visualization-matrix { };

    visualization-pictureit = callPackage ../applications/video/kodi/addons/visualization-pictureit { };

    visualization-projectm = callPackage ../applications/video/kodi/addons/visualization-projectm { };

    visualization-shadertoy = callPackage ../applications/video/kodi/addons/visualization-shadertoy { };

    visualization-spectrum = callPackage ../applications/video/kodi/addons/visualization-spectrum { };

    visualization-starburst = callPackage ../applications/video/kodi/addons/visualization-starburst { };

    visualization-waveform = callPackage ../applications/video/kodi/addons/visualization-waveform { };

    youtube = callPackage ../applications/video/kodi/addons/youtube { };

    # addon packages (dependencies)

    archive_tool = callPackage ../applications/video/kodi/addons/archive_tool { };

    certifi = callPackage ../applications/video/kodi/addons/certifi { };

    chardet = callPackage ../applications/video/kodi/addons/chardet { };

    dateutil = callPackage ../applications/video/kodi/addons/dateutil { };

    defusedxml = callPackage ../applications/video/kodi/addons/defusedxml { };

    future = callPackage ../applications/video/kodi/addons/future { };

    idna = callPackage ../applications/video/kodi/addons/idna { };

    infotagger = callPackage ../applications/video/kodi/addons/infotagger { };

    inputstream-adaptive = callPackage ../applications/video/kodi/addons/inputstream-adaptive { };

    inputstream-ffmpegdirect =
      callPackage ../applications/video/kodi/addons/inputstream-ffmpegdirect
        { };

    inputstream-rtmp = callPackage ../applications/video/kodi/addons/inputstream-rtmp { };

    inputstreamhelper = callPackage ../applications/video/kodi/addons/inputstreamhelper { };

    jurialmunkey = callPackage ../applications/video/kodi/addons/jurialmunkey { };

    kodi-six = callPackage ../applications/video/kodi/addons/kodi-six { };

    myconnpy = callPackage ../applications/video/kodi/addons/myconnpy { };

    plugin-cache = callPackage ../applications/video/kodi/addons/plugin-cache { };

    requests = callPackage ../applications/video/kodi/addons/requests { };

    requests-cache = callPackage ../applications/video/kodi/addons/requests-cache { };

    routing = callPackage ../applications/video/kodi/addons/routing { };

    sendtokodi = callPackage ../applications/video/kodi/addons/sendtokodi { };

    signals = callPackage ../applications/video/kodi/addons/signals { };

    simplecache = callPackage ../applications/video/kodi/addons/simplecache { };

    simplejson = callPackage ../applications/video/kodi/addons/simplejson { };

    six = callPackage ../applications/video/kodi/addons/six { };

    sponsorblock = callPackage ../applications/video/kodi/addons/sponsorblock { };

    urllib3 = callPackage ../applications/video/kodi/addons/urllib3 { };

    websocket = callPackage ../applications/video/kodi/addons/websocket { };

    xbmcswift2 = callPackage ../applications/video/kodi/addons/xbmcswift2 { };

    typing_extensions = callPackage ../applications/video/kodi/addons/typing_extensions { };

    arrow = callPackage ../applications/video/kodi/addons/arrow { };

    trakt-module = callPackage ../applications/video/kodi/addons/trakt-module { };

    trakt = callPackage ../applications/video/kodi/addons/trakt { };
  };
in
self
// optionalAttrs config.allowAliases {
  # deprecated or renamed packages

  controllers =
    throw
      "kodi.packages.controllers has been replaced with kodi.packages.controller-topology-project - a package which contains a large number of controller profiles."
      { };

  svtplay = throw "kodiPackages.svtplay has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-12
}
