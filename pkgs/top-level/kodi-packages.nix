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

    addonUpdateScript = callPackage ../by-name/ko/kodi/addons/addon-update-script/package.nix { };

    # package builders

    buildKodiAddon = callPackage ../by-name/ko/kodi/build-kodi-addon.nix { };

    buildKodiBinaryAddon = callPackage ../by-name/ko/kodi/build-kodi-binary-addon.nix { };

    # regular packages

    kodi-platform = callPackage ../by-name/ko/kodi/addons/kodi-platform/package.nix { };

    # addon packages

    a4ksubtitles = callPackage ../by-name/ko/kodi/addons/a4ksubtitles/package.nix { };

    arteplussept = callPackage ../by-name/ko/kodi/addons/arteplussept/package.nix { };

    bluetooth-manager = callPackage ../by-name/ko/kodi/addons/bluetooth-manager/package.nix { };

    controller-topology-project =
      callPackage ../by-name/ko/kodi/addons/controller-topology-project/package.nix
        { };

    formula1 = callPackage ../by-name/ko/kodi/addons/formula1/package.nix { };

    iagl = callPackage ../by-name/ko/kodi/addons/iagl/package.nix { };

    invidious = callPackage ../by-name/ko/kodi/addons/invidious/package.nix { };

    libretro = callPackage ../by-name/ko/kodi/addons/libretro/package.nix { };

    libretro-2048 = callPackage ../by-name/ko/kodi/addons/libretro-2048/package.nix {
      inherit twenty-fortyeight;
    };

    libretro-fuse = callPackage ../by-name/ko/kodi/addons/libretro-fuse/package.nix { inherit fuse; };

    libretro-genplus = callPackage ../by-name/ko/kodi/addons/libretro-genplus/package.nix {
      inherit genesis-plus-gx;
    };

    libretro-gw = callPackage ../by-name/ko/kodi/addons/libretro-gw/package.nix { inherit gw; };

    libretro-mgba = callPackage ../by-name/ko/kodi/addons/libretro-mgba/package.nix { inherit mgba; };

    libretro-nestopia = callPackage ../by-name/ko/kodi/addons/libretro-nestopia/package.nix {
      inherit nestopia;
    };

    libretro-snes9x = callPackage ../by-name/ko/kodi/addons/libretro-snes9x/package.nix {
      inherit snes9x;
    };

    jellycon = callPackage ../by-name/ko/kodi/addons/jellycon/package.nix { };

    jellyfin = callPackage ../by-name/ko/kodi/addons/jellyfin/package.nix { };

    joystick = callPackage ../by-name/ko/kodi/addons/joystick/package.nix { };

    keymap = callPackage ../by-name/ko/kodi/addons/keymap/package.nix { };

    mediacccde = callPackage ../by-name/ko/kodi/addons/mediacccde/package.nix { };

    mediathekview = callPackage ../by-name/ko/kodi/addons/mediathekview/package.nix { };

    netflix = callPackage ../by-name/ko/kodi/addons/netflix/package.nix { };

    plex-for-kodi = callPackage ../by-name/ko/kodi/addons/plex-for-kodi/package.nix { };

    orftvthek = callPackage ../by-name/ko/kodi/addons/orftvthek/package.nix { };

    radioparadise = callPackage ../by-name/ko/kodi/addons/radioparadise/package.nix { };

    raiplay = callPackage ../by-name/ko/kodi/addons/raiplay/package.nix { };

    robotocjksc = callPackage ../by-name/ko/kodi/addons/robotocjksc/package.nix { };

    screensaver-asteroids = callPackage ../by-name/ko/kodi/addons/screensaver-asteroids/package.nix { };

    skyvideoitalia = callPackage ../by-name/ko/kodi/addons/skyvideoitalia/package.nix { };

    steam-controller = callPackage ../by-name/ko/kodi/addons/steam-controller/package.nix { };

    steam-launcher = callPackage ../by-name/ko/kodi/addons/steam-launcher/package.nix { };

    steam-library = callPackage ../by-name/ko/kodi/addons/steam-library/package.nix { };

    somafm = callPackage ../by-name/ko/kodi/addons/somafm/package.nix { };

    pdfreader = callPackage ../by-name/ko/kodi/addons/pdfreader/package.nix { };

    pvr-hts = callPackage ../by-name/ko/kodi/addons/pvr-hts/package.nix { };

    pvr-hdhomerun = callPackage ../by-name/ko/kodi/addons/pvr-hdhomerun/package.nix { };

    pvr-iptvsimple = callPackage ../by-name/ko/kodi/addons/pvr-iptvsimple/package.nix { };

    pvr-vdr-vnsi = callPackage ../by-name/ko/kodi/addons/pvr-vdr-vnsi/package.nix { };

    osmc-skin = callPackage ../by-name/ko/kodi/addons/osmc-skin/package.nix { };

    texturemaker = callPackage ../by-name/ko/kodi/addons/texturemaker/package.nix { };

    upnext = callPackage ../by-name/ko/kodi/addons/upnext/package.nix { };

    vfs-libarchive = callPackage ../by-name/ko/kodi/addons/vfs-libarchive/package.nix { };

    vfs-rar = callPackage ../by-name/ko/kodi/addons/vfs-rar/package.nix { };

    vfs-sftp = callPackage ../by-name/ko/kodi/addons/vfs-sftp/package.nix { };

    visualization-fishbmc = callPackage ../by-name/ko/kodi/addons/visualization-fishbmc/package.nix { };

    visualization-goom = callPackage ../by-name/ko/kodi/addons/visualization-goom/package.nix { };

    visualization-matrix = callPackage ../by-name/ko/kodi/addons/visualization-matrix/package.nix { };

    visualization-pictureit =
      callPackage ../by-name/ko/kodi/addons/visualization-pictureit/package.nix
        { };

    visualization-projectm =
      callPackage ../by-name/ko/kodi/addons/visualization-projectm/package.nix
        { };

    visualization-shadertoy =
      callPackage ../by-name/ko/kodi/addons/visualization-shadertoy/package.nix
        { };

    visualization-spectrum =
      callPackage ../by-name/ko/kodi/addons/visualization-spectrum/package.nix
        { };

    visualization-starburst =
      callPackage ../by-name/ko/kodi/addons/visualization-starburst/package.nix
        { };

    visualization-waveform =
      callPackage ../by-name/ko/kodi/addons/visualization-waveform/package.nix
        { };

    youtube = callPackage ../by-name/ko/kodi/addons/youtube/package.nix { };

    # addon packages (dependencies)

    archive_tool = callPackage ../by-name/ko/kodi/addons/archive_tool/package.nix { };

    certifi = callPackage ../by-name/ko/kodi/addons/certifi/package.nix { };

    chardet = callPackage ../by-name/ko/kodi/addons/chardet/package.nix { };

    dateutil = callPackage ../by-name/ko/kodi/addons/dateutil/package.nix { };

    defusedxml = callPackage ../by-name/ko/kodi/addons/defusedxml/package.nix { };

    future = callPackage ../by-name/ko/kodi/addons/future/package.nix { };

    idna = callPackage ../by-name/ko/kodi/addons/idna/package.nix { };

    infotagger = callPackage ../by-name/ko/kodi/addons/infotagger/package.nix { };

    inputstream-adaptive = callPackage ../by-name/ko/kodi/addons/inputstream-adaptive/package.nix { };

    inputstream-ffmpegdirect =
      callPackage ../by-name/ko/kodi/addons/inputstream-ffmpegdirect/package.nix
        { };

    inputstream-rtmp = callPackage ../by-name/ko/kodi/addons/inputstream-rtmp/package.nix { };

    inputstreamhelper = callPackage ../by-name/ko/kodi/addons/inputstreamhelper/package.nix { };

    jurialmunkey = callPackage ../by-name/ko/kodi/addons/jurialmunkey/package.nix { };

    kodi-six = callPackage ../by-name/ko/kodi/addons/kodi-six/package.nix { };

    myconnpy = callPackage ../by-name/ko/kodi/addons/myconnpy/package.nix { };

    plugin-cache = callPackage ../by-name/ko/kodi/addons/plugin-cache/package.nix { };

    requests = callPackage ../by-name/ko/kodi/addons/requests/package.nix { };

    requests-cache = callPackage ../by-name/ko/kodi/addons/requests-cache/package.nix { };

    routing = callPackage ../by-name/ko/kodi/addons/routing/package.nix { };

    sendtokodi = callPackage ../by-name/ko/kodi/addons/sendtokodi/package.nix { };

    signals = callPackage ../by-name/ko/kodi/addons/signals/package.nix { };

    simplecache = callPackage ../by-name/ko/kodi/addons/simplecache/package.nix { };

    simplejson = callPackage ../by-name/ko/kodi/addons/simplejson/package.nix { };

    six = callPackage ../by-name/ko/kodi/addons/six/package.nix { };

    sponsorblock = callPackage ../by-name/ko/kodi/addons/sponsorblock/package.nix { };

    urllib3 = callPackage ../by-name/ko/kodi/addons/urllib3/package.nix { };

    websocket = callPackage ../by-name/ko/kodi/addons/websocket/package.nix { };

    xbmcswift2 = callPackage ../by-name/ko/kodi/addons/xbmcswift2/package.nix { };

    typing_extensions = callPackage ../by-name/ko/kodi/addons/typing_extensions/package.nix { };

    arrow = callPackage ../by-name/ko/kodi/addons/arrow/package.nix { };

    trakt-module = callPackage ../by-name/ko/kodi/addons/trakt-module/package.nix { };

    trakt = callPackage ../by-name/ko/kodi/addons/trakt/package.nix { };
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
