{
  stdenv,
  config,
  callPackage,
  wineBuild,
}:

rec {
  fonts = callPackage ../applications/emulators/wine/fonts.nix { };
  minimal = callPackage ../applications/emulators/wine {
    wineRelease = config.wine.release or "stable";
    inherit wineBuild;
  };

  base = minimal.override {
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
  };

  full = base.override {
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

  stable = base.override { wineRelease = "stable"; };
  stableFull = full.override { wineRelease = "stable"; };

  unstable = base.override { wineRelease = "unstable"; };
  unstableFull = full.override { wineRelease = "unstable"; };

  staging = base.override { wineRelease = "staging"; };
  stagingFull = full.override { wineRelease = "staging"; };

  wayland = base.override {
    wineRelease = "wayland";
    waylandSupport = true;
  };
  waylandFull = full.override {
    wineRelease = "wayland";
    waylandSupport = true;
  };
}
