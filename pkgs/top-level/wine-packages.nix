{
  lib,
  stdenv,
  config,
  # not for anything bound in the package set, do note
  pkgs,
  newScope,
  wineBuild,
}:

lib.makeExtensible (
  self:
  let
    callPackage = newScope self;
  in
  {
    inherit callPackage wineBuild;

    fonts = callPackage ../applications/emulators/wine/fonts.nix { };
    minimal = callPackage ../applications/emulators/wine {
      wineRelease = config.wine.release or "stable";
      inherit wineBuild;
    };

    base = self.minimal.override {
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

    full = self.base.override {
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

    stable = self.base.override { wineRelease = "stable"; };
    stableFull = self.full.override { wineRelease = "stable"; };

    unstable = self.base.override { wineRelease = "unstable"; };
    unstableFull = self.full.override { wineRelease = "unstable"; };

    staging = self.base.override { wineRelease = "staging"; };
    stagingFull = self.full.override { wineRelease = "staging"; };

    wayland = self.base.override {
      x11Support = false;
    };
    waylandFull = self.full.override {
      x11Support = false;
    };

    yabridge =
      let
        yabridge = self.base.override { wineRelease = "yabridge"; };
      in
      if wineBuild == "wineWow" then yabridge else lib.dontDistribute yabridge;
  }
)
