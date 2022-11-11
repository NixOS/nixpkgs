{ stdenv, config, callPackage, wineBuild }:

rec {
  fonts = callPackage ../applications/emulators/wine/fonts.nix {};
  minimal = callPackage ../applications/emulators/wine {
    wineRelease = config.wine.release or "stable";
    inherit wineBuild;
  };

  base = minimal.override {
    gettextSupport = true;
    fontconfigSupport = stdenv.isLinux;
    alsaSupport = stdenv.isLinux;
    openglSupport = true;
    vulkanSupport = true;
    tlsSupport = true;
    cupsSupport = true;
    dbusSupport = stdenv.isLinux;
    cairoSupport = stdenv.isLinux;
    cursesSupport = true;
    saneSupport = stdenv.isLinux;
    pulseaudioSupport = config.pulseaudio or stdenv.isLinux;
    udevSupport = stdenv.isLinux;
    xineramaSupport = stdenv.isLinux;
    sdlSupport = true;
    mingwSupport = true;
    usbSupport = true;
  };

  full = base.override {
    gtkSupport = stdenv.isLinux;
    gstreamerSupport = true;
    openalSupport = true;
    openclSupport = true;
    odbcSupport = true;
    netapiSupport = stdenv.isLinux;
    vaSupport = stdenv.isLinux;
    pcapSupport = true;
    v4lSupport = stdenv.isLinux;
    gphoto2Support = true;
    krb5Support = true;
    ldapSupport = true;
    vkd3dSupport = stdenv.isLinux;
    embedInstallers = true;
  };

  stable = base.override { wineRelease = "stable"; };
  stableFull = full.override { wineRelease = "stable"; };

  unstable = base.override { wineRelease = "unstable"; };
  unstableFull = full.override { wineRelease = "unstable"; };

  staging = base.override { wineRelease = "staging"; };
  stagingFull = full.override { wineRelease = "staging"; };

  wayland = base.override { wineRelease = "wayland"; };
  waylandFull = full.override { wineRelease = "wayland"; };
}
