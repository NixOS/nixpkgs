{ stdenv, config, callPackage, wineBuild }:

rec {
  fonts = callPackage ../misc/emulators/wine/fonts.nix {};
  minimal = callPackage ../misc/emulators/wine {
    wineRelease = config.wine.release or "stable";
    inherit wineBuild;
  };

  base = minimal.override {
    pngSupport = true;
    jpegSupport = true;
    tiffSupport = true;
    gettextSupport = true;
    fontconfigSupport = true;
    alsaSupport = true;
    openglSupport = true;
    vulkanSupport = stdenv.isLinux;
    tlsSupport = true;
    cupsSupport = true;
    dbusSupport = true;
    cairoSupport = true;
    cursesSupport = true;
    saneSupport = true;
    pulseaudioSupport = config.pulseaudio or stdenv.isLinux;
    udevSupport = true;
    xineramaSupport = true;
    xmlSupport = true;
    sdlSupport = true;
    mingwSupport = true;
  };

  full = base.override {
    gtkSupport = true;
    gstreamerSupport = true;
    colorManagementSupport = true;
    mpg123Support = true;
    openalSupport = true;
    openclSupport = true;
    odbcSupport = true;
    netapiSupport = true;
    vaSupport = true;
    pcapSupport = true;
    v4lSupport = true;
    gsmSupport = true;
    gphoto2Support = true;
    ldapSupport = true;
    faudioSupport = true;
    vkd3dSupport = true;
    embedInstallers = true;
  };

  stable = base.override { wineRelease = "stable"; };
  stableFull = full.override { wineRelease = "stable"; };

  unstable = base.override { wineRelease = "unstable"; };
  unstableFull = full.override { wineRelease = "unstable"; };

  staging = base.override { wineRelease = "staging"; };
  stagingFull = full.override { wineRelease = "staging"; };
}
