# Qt packages set.
#
# Attributes in this file are packages requiring Qt and will be made available
# for every Qt version. Qt applications are called from `all-packages.nix` via
# this file.

{ lib
, __splicedPackages
, makeScopeWithSplicing'
, generateSplicesForMkScope
, stdenv
, pkgsHostTarget
}:

let
  pkgs = __splicedPackages;
  # qt6 set should not be pre-spliced to prevent spliced packages being a part of an unspliced set
  # 'pkgsCross.aarch64-multiplatform.pkgsBuildTarget.targetPackages.qt6Packages.qtbase' should not have a `__spliced` but if qt6 is pre-spliced then it will have one.
  # pkgsHostTarget == pkgs
  qt6 = pkgsHostTarget.qt6;
in

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "qt6Packages";
  f = (self: let
    inherit (self) callPackage;
    noExtraAttrs = set: lib.attrsets.removeAttrs set [ "extend" "override" "overrideScope" "overrideScope'" "overrideDerivation" ];
  in (noExtraAttrs qt6) // {
  inherit stdenv;

  # LIBRARIES

  qt6ct = callPackage ../tools/misc/qt6ct { };

  qt6gtk2 = callPackage ../tools/misc/qt6gtk2 { };

  qtkeychain = callPackage ../development/libraries/qtkeychain {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  qtpbfimageplugin = callPackage ../development/libraries/qtpbfimageplugin { };

  qtstyleplugin-kvantum = callPackage ../development/libraries/qtstyleplugin-kvantum {
    qt5Kvantum = pkgs.libsForQt5.qtstyleplugin-kvantum;
  };

  quazip = callPackage ../development/libraries/quazip { };

  qscintilla = callPackage ../development/libraries/qscintilla { };

  qxlsx = callPackage ../development/libraries/qxlsx { };

  qzxing = callPackage ../development/libraries/qzxing { };

  poppler = callPackage ../development/libraries/poppler {
    lcms = pkgs.lcms2;
    qt6Support = true;
    suffix = "qt6";
  };

  } // lib.optionalAttrs pkgs.config.allowAliases {
    # Convert to a throw on 01-01-2023.
    # Warnings show up in various cli tool outputs, throws do not.
    # Remove completely before 24.05
    overrideScope' = lib.warn "qt6Packages now uses makeScopeWithSplicing which does not have \"overrideScope'\", use \"overrideScope\"." self.overrideScope;
  });
}
