# Qt packages set.
#
# Attributes in this file are packages requiring Qt and will be made available
# for every Qt version. Qt applications are called from `all-packages.nix` via
# this file.

{ lib
, pkgs
, qt6
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
  # LIBRARIES

  inherit (kdeFrameworks) kcoreaddons;

  quazip = callPackage ../development/libraries/quazip { };

  qxlsx = callPackage ../development/libraries/qxlsx { };

  poppler = callPackage ../development/libraries/poppler {
    lcms = pkgs.lcms2;
    qt6Support = true;
    suffix = "qt6";
  };
})))
