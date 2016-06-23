## Configuration:
# Control you default wine config in nixpkgs-config:
# wine = {
#   release = "stable"; # "stable", "unstable", "staging"
#   build = "wineWow"; # "wine32", "wine64", "wineWow"
# };
# Make additional configurations on demand:
# wine.override { wineBuild = "wine32"; wineRelease = "staging"; };
{ lib, pkgs, system, callPackage,
  wineRelease ? "stable",
  wineBuild ? (if system == "x86_64-linux" then "wineWow" else "wine32"),
  libtxc_dxtn_Name ? "libtxc_dxtn_s2tc",
  pngSupport ? true,
  jpegSupport ? true,
  tiffSupport ? false,
  gettextSupport ? true,
  fontconfigSupport ? true,
  alsaSupport ? true,
  gtkSupport ? false,
  openglSupport ? true,
  tlsSupport ? true,
  gstreamerSupport ? false,
  cupsSupport ? true,
  colorManagementSupport ? true,
  dbusSupport ? true,
  mpg123Support ? true,
  openalSupport ? true,
  openclSupport ? false,
  cairoSupport ? true,
  odbcSupport ? false,
  netapiSupport ? false,
  cursesSupport ? true,
  vaSupport ? false,
  pcapSupport ? false,
  v4lSupport ? false,
  saneSupport ? false,
  gsmSupport ? false,
  gphoto2Support ? false,
  ldapSupport ? false,
  pulseaudioSupport ? true,
  xineramaSupport ? true,
  xmlSupport ? true }:

let wine-build = build: release:
      lib.getAttr build (callPackage ./packages.nix {
        wineRelease = release;
        supportFlags = {
          inherit pngSupport jpegSupport cupsSupport colorManagementSupport gettextSupport
                  dbusSupport mpg123Support openalSupport cairoSupport tiffSupport odbcSupport
                  netapiSupport cursesSupport vaSupport pcapSupport v4lSupport saneSupport
                  gsmSupport gphoto2Support ldapSupport fontconfigSupport alsaSupport
                  pulseaudioSupport xineramaSupport gtkSupport openclSupport xmlSupport tlsSupport
                  openglSupport gstreamerSupport;
        };
      });

in if wineRelease == "staging" then
  callPackage ./staging.nix {
    inherit libtxc_dxtn_Name;
    wineUnstable = wine-build wineBuild "unstable";
  }
else
  wine-build wineBuild wineRelease
