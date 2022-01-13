## Configuration:
# Control you default wine config in nixpkgs-config:
# wine = {
#   release = "stable"; # "stable", "unstable", "staging", "wayland"
#   build = "wineWow"; # "wine32", "wine64", "wineWow"
# };
# Make additional configurations on demand:
# wine.override { wineBuild = "wine32"; wineRelease = "staging"; };
{ lib, stdenv, callPackage,
  pkgs,
  pkgsi686Linux,
  wineRelease ? "stable",
  wineBuild ? if stdenv.hostPlatform.system == "x86_64-linux" then "wineWow" else "wine32",
  pngSupport ? false,
  jpegSupport ? false,
  tiffSupport ? false,
  gettextSupport ? false,
  fontconfigSupport ? false,
  alsaSupport ? false,
  gtkSupport ? false,
  openglSupport ? false,
  tlsSupport ? false,
  gstreamerSupport ? false,
  cupsSupport ? false,
  colorManagementSupport ? false,
  dbusSupport ? false,
  mpg123Support ? false,
  openalSupport ? false,
  openclSupport ? false,
  cairoSupport ? false,
  odbcSupport ? false,
  netapiSupport ? false,
  cursesSupport ? false,
  vaSupport ? false,
  pcapSupport ? false,
  v4lSupport ? false,
  saneSupport ? false,
  gsmSupport ? false,
  gphoto2Support ? false,
  ldapSupport ? false,
  pulseaudioSupport ? false,
  udevSupport ? false,
  xineramaSupport ? false,
  xmlSupport ? false,
  vulkanSupport ? false,
  sdlSupport ? false,
  faudioSupport ? false,
  vkd3dSupport ? false,
  mingwSupport ? wineRelease != "stable",
  embedInstallers ? false # The Mono and Gecko MSI installers
}:

let wine-build = build: release:
      lib.getAttr build (callPackage ./packages.nix {
        wineRelease = release;
        supportFlags = {
          inherit pngSupport jpegSupport cupsSupport colorManagementSupport gettextSupport
                  dbusSupport mpg123Support openalSupport cairoSupport tiffSupport odbcSupport
                  netapiSupport cursesSupport vaSupport pcapSupport v4lSupport saneSupport
                  gsmSupport gphoto2Support ldapSupport fontconfigSupport alsaSupport
                  pulseaudioSupport xineramaSupport gtkSupport openclSupport xmlSupport tlsSupport
                  openglSupport gstreamerSupport udevSupport vulkanSupport sdlSupport faudioSupport
                  vkd3dSupport mingwSupport embedInstallers;
        };
      });

in if wineRelease == "staging" then
  callPackage ./staging.nix {
    wineUnstable = wine-build wineBuild "unstable";
  }
else
  (if wineRelease == "wayland" then
    callPackage ./wayland.nix {
      wineWayland = wine-build wineBuild "wayland";
      inherit pulseaudioSupport vulkanSupport vkd3dSupport;

      pkgArches = lib.optionals (wineBuild == "wine32" || wineBuild == "wineWow") [ pkgsi686Linux ] ++ lib.optionals (wineBuild == "wine64" || wineBuild == "wineWow") [ pkgs ];
    }
    else
      wine-build wineBuild wineRelease
  )
