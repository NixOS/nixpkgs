{
  lib,
  stdenv,
  config,
  # not for anything bound in the package set, do note
  pkgs,
  newScope,
}:

let
  sources = import ../applications/emulators/wine/sources.nix { inherit pkgs; };

  baseFlags = {
    gettextSupport = true;
    fontconfigSupport = stdenv.hostPlatform.isLinux;
    alsaSupport = stdenv.hostPlatform.isLinux;
    openglSupport = true;
    vulkanSupport = true;
    tlsSupport = true;
    cupsSupport = true;
    dbusSupport = stdenv.hostPlatform.isLinux;
    cairoSupport = stdenv.hostPlatform.isLinux;
    cursesSupport = true;
    saneSupport = stdenv.hostPlatform.isLinux;
    pulseaudioSupport = config.pulseaudio or stdenv.hostPlatform.isLinux;
    udevSupport = stdenv.hostPlatform.isLinux;
    xineramaSupport = stdenv.hostPlatform.isLinux;
    sdlSupport = true;
    mingwSupport = true;
    usbSupport = true;
    waylandSupport = stdenv.hostPlatform.isLinux;
    x11Support = stdenv.hostPlatform.isLinux;
    ffmpegSupport = true;
  };

  fullFlags = baseFlags // {
    gtkSupport = stdenv.hostPlatform.isLinux;
    gstreamerSupport = true;
    openclSupport = true;
    odbcSupport = true;
    netapiSupport = stdenv.hostPlatform.isLinux;
    vaSupport = stdenv.hostPlatform.isLinux;
    pcapSupport = true;
    v4lSupport = stdenv.hostPlatform.isLinux;
    gphoto2Support = true;
    krb5Support = true;
    embedInstallers = true;
  };

in

lib.makeExtensible (
  self:
  let
    callPackage = newScope self;

    # Map user-facing release names to sources, pname suffix, and staging flag
    releaseInfo = {
      stable = {
        src = sources.stable;
        useStaging = false;
      };
      unstable = {
        src = sources.unstable;
        useStaging = false;
      };
      # Many versions have a "staging" variant, but when we say "staging",
      # the version we want to use is "unstable".
      staging = {
        src = sources.unstable;
        pnameSuffix = "-staging";
        useStaging = true;
      };
      # "yabridge" enables staging too --- we are not interested in
      # yabridge without the staging patches applied.
      yabridge = {
        src = sources.yabridge;
        pnameSuffix = "-yabridge";
        useStaging = true;
      };
      wayland = {
        src = sources.stable;
        useStaging = false;
        x11Support = false;
      };
    };

    defaultRelease = config.wine.release or "stable";

    # Returns { wine32, wine64, wineWow, wineWow64 } for given flags and release info
    mkWine = flags: info: callPackage ../applications/emulators/wine/packages.nix (flags // info);

    mkVariants = flags: lib.mapAttrs (_: mkWine flags) (removeAttrs releaseInfo [ "yabridge" ]);

    bases = mkVariants baseFlags;
    fulls = mkVariants fullFlags;

  in
  bases
  // lib.mapAttrs' (name: pkg: lib.nameValuePair "${name}Full" pkg) fulls
  // {
    inherit callPackage;

    fonts = callPackage ../applications/emulators/wine/fonts.nix { };

    minimal = mkWine { } releaseInfo.${defaultRelease};
    base = bases.${defaultRelease};
    full = fulls.${defaultRelease};

    yabridge =
      let
        builds = mkWine baseFlags releaseInfo.yabridge;
        applyOverride =
          pkg:
          pkg.overrideAttrs (old: {
            env = old.env // {
              NIX_CFLAGS_COMPILE = "-std=gnu17";
            };
          });
      in
      lib.mapAttrs (
        name: pkg:
        let
          modified = applyOverride pkg;
        in
        if name == "wineWow" then modified else lib.dontDistribute modified
      ) builds;
  }
)
