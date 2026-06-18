{
  lib,
  fetchurl,
  qt6Packages,
  cmark,
  taglib,
  wayland-protocols,
  wayland,
  zxing-cpp,
}:

let
  sets = [
    "gear"
    "frameworks"
    "plasma"
  ];

  frameworks = import ./frameworks;
  gear = import ./gear;
  plasma = import ./plasma;

  loadUrls = set: lib.importJSON (./generated/sources + "/${set}.json");
  allUrls = lib.attrsets.mergeAttrsList (map loadUrls sets);

  allPackages = final: prev: {
    sources = lib.mapAttrs (
      _: v:
      (fetchurl {
        inherit (v) url hash;
      })
      // {
        inherit (v) version;
      }
    ) allUrls;

    # Aliases to simplify test-building entire package sets
    inherit (final)
      frameworks
      gear
      plasma
      ;

    mkKdeDerivation = final.callPackage (import ./lib/mk-kde-derivation.nix final) { };

    # THIRD PARTY
    inherit
      cmark
      taglib
      wayland
      wayland-protocols
      zxing-cpp
      ;

    # Alias to match metadata
    kquickimageeditor = final.kquickimageedit;

    selenium-webdriver-at-spi = null; # Used for integration tests that we don't run, stub

    alpaka = final.callPackage ./misc/alpaka { };
    glaxnimate = final.callPackage ./misc/glaxnimate { };
    kdiagram = final.callPackage ./misc/kdiagram { };
    kdevelop-pg-qt = final.callPackage ./misc/kdevelop-pg-qt { };
    kdsoap-ws-discovery-client = final.callPackage ./misc/kdsoap-ws-discovery-client { };
    kirigami-addons = final.callPackage ./misc/kirigami-addons { };
    kio-extras-kf5 = final.callPackage ./misc/kio-extras-kf5 { };
    kio-fuse = final.callPackage ./misc/kio-fuse { };
    klevernotes = final.callPackage ./misc/klevernotes { };
    ktextaddons = final.callPackage ./misc/ktextaddons { };
    kup = final.callPackage ./misc/kup { };
    marknote = final.callPackage ./misc/marknote { };
    mpvqt = final.callPackage ./misc/mpvqt { };
    oxygen-icons = final.callPackage ./misc/oxygen-icons { };
    phonon = final.callPackage ./misc/phonon { };
    phonon-vlc = final.callPackage ./misc/phonon-vlc { };
    plasma-pass = final.callPackage ./misc/plasma-pass { };
    plasma-wayland-protocols = final.callPackage ./misc/plasma-wayland-protocols { };
    polkit-qt-1 = final.callPackage ./misc/polkit-qt-1 { };
    pulseaudio-qt = final.callPackage ./misc/pulseaudio-qt { };

    applet-window-buttons6 = final.callPackage ./third-party/applet-window-buttons6 { };
    dynamic-workspaces = final.callPackage ./third-party/dynamic-workspaces { };
    karousel = final.callPackage ./third-party/karousel { };
    koi = final.callPackage ./third-party/koi { };
    krohnkite = final.callPackage ./third-party/krohnkite { };
    kzones = final.callPackage ./third-party/kzones { };
    wallpaper-engine-plugin = final.callPackage ./third-party/wallpaper-engine-plugin { };
  };
in

qt6Packages.overrideScope (
  lib.fixedPoints.composeManyExtensions [
    frameworks
    gear
    plasma
    allPackages
  ]
)
