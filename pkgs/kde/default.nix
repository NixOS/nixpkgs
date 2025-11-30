{
  lib,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  fetchurl,
  qt6Packages,
  cmark,
  gpgme,
  taglib,
  wayland-protocols,
  wayland,
  zxing-cpp,
}:
let
  allPackages =
    self:
    let
      frameworks = import ./frameworks { inherit (self) callPackage; };
      gear = import ./gear { inherit (self) callPackage; };
      plasma = import ./plasma { inherit (self) callPackage; };

      sets = [
        "gear"
        "frameworks"
        "plasma"
      ];

      loadUrls = set: lib.importJSON (./generated/sources + "/${set}.json");
      allUrls = lib.attrsets.mergeAttrsList (map loadUrls sets);

      sources = lib.mapAttrs (
        _: v:
        (fetchurl {
          inherit (v) url hash;
        })
        // {
          inherit (v) version;
        }
      ) allUrls;

      debugAlias = set: lib.dontRecurseIntoAttrs (lib.filterAttrs (k: v: !v.meta.broken) set);
    in
    (
      qt6Packages
      // frameworks
      // gear
      // plasma
      // {
        inherit sources;

        # Aliases to simplify test-building entire package sets
        frameworks = debugAlias frameworks;
        gear = debugAlias gear;
        plasma = debugAlias plasma;

        mkKdeDerivation = self.callPackage (import ./lib/mk-kde-derivation.nix self) { };

        # THIRD PARTY
        inherit
          cmark
          gpgme
          taglib
          wayland
          wayland-protocols
          zxing-cpp
          ;

        # Alias to match metadata
        kquickimageeditor = self.kquickimageedit;

        selenium-webdriver-at-spi = null; # Used for integration tests that we don't run, stub

        alpaka = self.callPackage ./misc/alpaka { };
        glaxnimate = self.callPackage ./misc/glaxnimate { };
        kdiagram = self.callPackage ./misc/kdiagram { };
        kdevelop-pg-qt = self.callPackage ./misc/kdevelop-pg-qt { };
        kdsoap-ws-discovery-client = self.callPackage ./misc/kdsoap-ws-discovery-client { };
        kirigami-addons = self.callPackage ./misc/kirigami-addons { };
        kio-extras-kf5 = self.callPackage ./misc/kio-extras-kf5 { };
        kio-fuse = self.callPackage ./misc/kio-fuse { };
        klevernotes = self.callPackage ./misc/klevernotes { };
        ktextaddons = self.callPackage ./misc/ktextaddons { };
        kup = self.callPackage ./misc/kup { };
        marknote = self.callPackage ./misc/marknote { };
        mpvqt = self.callPackage ./misc/mpvqt { };
        oxygen-icons = self.callPackage ./misc/oxygen-icons { };
        phonon = self.callPackage ./misc/phonon { };
        phonon-vlc = self.callPackage ./misc/phonon-vlc { };
        plasma-keyboard = self.callPackage ./misc/plasma-keyboard { };
        plasma-wayland-protocols = self.callPackage ./misc/plasma-wayland-protocols { };
        polkit-qt-1 = self.callPackage ./misc/polkit-qt-1 { };
        pulseaudio-qt = self.callPackage ./misc/pulseaudio-qt { };

        applet-window-buttons6 = self.callPackage ./third-party/applet-window-buttons6 { };
        dynamic-workspaces = self.callPackage ./third-party/dynamic-workspaces { };
        karousel = self.callPackage ./third-party/karousel { };
        koi = self.callPackage ./third-party/koi { };
        krohnkite = self.callPackage ./third-party/krohnkite { };
        kzones = self.callPackage ./third-party/kzones { };
        wallpaper-engine-plugin = self.callPackage ./third-party/wallpaper-engine-plugin { };
      }
    );
in
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "kdePackages";
  f = allPackages;
}
