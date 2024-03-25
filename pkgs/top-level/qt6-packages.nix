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
, kdePackages
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
  accounts-qt = callPackage ../development/libraries/accounts-qt { };
  appstream-qt = callPackage ../development/libraries/appstream/qt.nix { };

  drumstick = callPackage ../development/libraries/drumstick { };

  fcitx5-chinese-addons = callPackage ../tools/inputmethods/fcitx5/fcitx5-chinese-addons.nix { };

  fcitx5-configtool = kdePackages.callPackage ../tools/inputmethods/fcitx5/fcitx5-configtool.nix { };

  fcitx5-qt = callPackage ../tools/inputmethods/fcitx5/fcitx5-qt.nix { };

  fcitx5-skk-qt = callPackage ../tools/inputmethods/fcitx5/fcitx5-skk.nix { enableQt = true; };

  fcitx5-unikey = callPackage ../tools/inputmethods/fcitx5/fcitx5-unikey.nix { };

  fcitx5-with-addons = callPackage ../tools/inputmethods/fcitx5/with-addons.nix { };

  kdsoap = callPackage ../development/libraries/kdsoap { };

  kcolorpicker = callPackage ../development/libraries/kcolorpicker { };
  kimageannotator = callPackage ../development/libraries/kimageannotator { };

  futuresql = callPackage ../development/libraries/futuresql { };
  kquickimageedit = callPackage ../development/libraries/kquickimageedit { };
  libqaccessibilityclient = callPackage ../development/libraries/libqaccessibilityclient { };
  libquotient = callPackage ../development/libraries/libquotient { };
  mlt = pkgs.mlt.override {
    qt = qt6;
  };

  qca = pkgs.darwin.apple_sdk_11_0.callPackage ../development/libraries/qca {
    inherit (qt6) qtbase qt5compat;
  };
  qcoro = callPackage ../development/libraries/qcoro { };
  qgpgme = callPackage ../development/libraries/gpgme { };
  packagekit-qt = callPackage ../tools/package-management/packagekit/qt.nix { };

  qt6ct = callPackage ../tools/misc/qt6ct { };

  qt6gtk2 = callPackage ../tools/misc/qt6gtk2 { };

  qtforkawesome = callPackage ../development/libraries/qtforkawesome { };

  qtkeychain = callPackage ../development/libraries/qtkeychain {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  qtpbfimageplugin = callPackage ../development/libraries/qtpbfimageplugin { };

  qtstyleplugin-kvantum = callPackage ../development/libraries/qtstyleplugin-kvantum {
    qt5Kvantum = pkgs.libsForQt5.qtstyleplugin-kvantum;
  };

  qtutilities = callPackage ../development/libraries/qtutilities { };

  quazip = callPackage ../development/libraries/quazip { };

  qscintilla = callPackage ../development/libraries/qscintilla { };

  qwlroots = callPackage ../development/libraries/qwlroots {
    wlroots = pkgs.wlroots_0_17;
  };

  qxlsx = callPackage ../development/libraries/qxlsx { };

  qzxing = callPackage ../development/libraries/qzxing { };

  poppler = callPackage ../development/libraries/poppler {
    lcms = pkgs.lcms2;
    qt6Support = true;
    suffix = "qt6";
  };

  # Not a library, but we do want it to be built for every qt version there
  # is, to allow users to choose the right build if needed.
  sddm = callPackage ../applications/display-managers/sddm {};

  signond = callPackage ../development/libraries/signond {};

  waylib = callPackage ../development/libraries/waylib { };

  wayqt = callPackage ../development/libraries/wayqt { };

  } // lib.optionalAttrs pkgs.config.allowAliases {
    # Convert to a throw on 01-01-2023.
    # Warnings show up in various cli tool outputs, throws do not.
    # Remove completely before 24.05
    overrideScope' = lib.warn "qt6Packages now uses makeScopeWithSplicing which does not have \"overrideScope'\", use \"overrideScope\"." self.overrideScope;
  });
}
