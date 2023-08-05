# Qt packages set.
#
# Attributes in this file are packages requiring Qt and will be made available
# for every Qt version. Qt applications are called from `all-packages.nix` via
# this file.

{ lib
, pkgs
, qt6
, stdenv
}:

(lib.makeScope pkgs.newScope ( self:

let
  libsForQt6 = self;
  callPackage = self.callPackage;
  kdeFrameworks = let
    mkFrameworks = import ../development/libraries/kde-frameworks;
    attrs = {
      libsForQt5 = libsForQt6;
      inherit (pkgs) lib fetchurl;
    };
  in (lib.makeOverridable mkFrameworks attrs);
in

(qt6 // {
  inherit stdenv;

  # LIBRARIES

  inherit (kdeFrameworks) kcoreaddons;

  qt6ct = callPackage ../tools/misc/qt6ct { };

  qt6gtk2 = callPackage ../tools/misc/qt6gtk2 { };

  qtkeychain = callPackage ../development/libraries/qtkeychain {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  qtpbfimageplugin = callPackage ../development/libraries/qtpbfimageplugin { };

  qtstyleplugin-kvantum = callPackage ../development/libraries/qtstyleplugin-kvantum { };

  quazip = callPackage ../development/libraries/quazip { };

  qxlsx = callPackage ../development/libraries/qxlsx { };

  poppler = callPackage ../development/libraries/poppler {
    lcms = pkgs.lcms2;
    qt6Support = true;
    suffix = "qt6";
  };
})))
