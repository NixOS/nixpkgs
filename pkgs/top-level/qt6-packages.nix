# Qt packages set.
#
# Attributes in this file are packages requiring Qt and will be made available
# for every Qt version. Qt applications are called from `all-packages.nix` via
# this file.

{
  lib,
  config,
  __splicedPackages,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  stdenv,
  pkgsHostTarget,
  kdePackages,
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
  f = (
    self:
    let
      inherit (self) callPackage;
      noExtraAttrs =
        set:
        lib.attrsets.removeAttrs set [
          "extend"
          "override"
          "overrideScope"
          "overrideDerivation"
        ];
    in
    (noExtraAttrs qt6)
    // {

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

      libiodata = callPackage ../development/libraries/libiodata { };

      libqaccessibilityclient = callPackage ../development/libraries/libqaccessibilityclient { };

      libqglviewer = callPackage ../development/libraries/libqglviewer { };

      libqtpas = callPackage ../development/compilers/fpc/libqtpas.nix { };

      libquotient = callPackage ../development/libraries/libquotient { };
      mlt = pkgs.mlt.override {
        qt = qt6;
      };

      maplibre-native-qt = callPackage ../development/libraries/maplibre-native-qt { };

      qca = callPackage ../development/libraries/qca {
        inherit (qt6) qtbase qt5compat;
      };
      qcoro = callPackage ../development/libraries/qcoro { };
      qcustomplot = callPackage ../development/libraries/qcustomplot { };
      qgpgme = callPackage ../development/libraries/gpgme { };
      qhotkey = callPackage ../development/libraries/qhotkey { };
      qmlbox2d = callPackage ../development/libraries/qmlbox2d { };
      packagekit-qt = callPackage ../tools/package-management/packagekit/qt.nix { };

      qodeassist-plugin = callPackage ../development/libraries/qodeassist-plugin { };

      qt6ct = callPackage ../tools/misc/qt6ct { };

      qt6gtk2 = callPackage ../tools/misc/qt6gtk2 { };

      qt-color-widgets = callPackage ../development/libraries/qt-color-widgets { };

      qtforkawesome = callPackage ../development/libraries/qtforkawesome { };

      qtkeychain = callPackage ../development/libraries/qtkeychain { };

      qtpbfimageplugin = callPackage ../development/libraries/qtpbfimageplugin { };

      qtstyleplugin-kvantum = kdePackages.callPackage ../development/libraries/qtstyleplugin-kvantum { };

      qtutilities = callPackage ../development/libraries/qtutilities { };

      qt-jdenticon = callPackage ../development/libraries/qt-jdenticon { };

      quazip = callPackage ../development/libraries/quazip { };

      qscintilla = callPackage ../development/libraries/qscintilla { };

      qtspell = callPackage ../development/libraries/qtspell { };

      qwlroots = callPackage ../development/libraries/qwlroots {
        wlroots = pkgs.wlroots_0_18;
      };

      qwt = callPackage ../development/libraries/qwt/default.nix { };

      qxlsx = callPackage ../development/libraries/qxlsx { };

      qzxing = callPackage ../development/libraries/qzxing { };

      poppler = callPackage ../development/libraries/poppler {
        lcms = pkgs.lcms2;
        qt6Support = true;
        suffix = "qt6";
      };

      sailfish-access-control-plugin =
        callPackage ../development/libraries/sailfish-access-control-plugin
          { };

      sddm = kdePackages.callPackage ../applications/display-managers/sddm { };

      sierra-breeze-enhanced =
        kdePackages.callPackage ../data/themes/kwin-decorations/sierra-breeze-enhanced
          { };

      signond = callPackage ../development/libraries/signond { };

      timed = callPackage ../applications/system/timed { };

      waylib = callPackage ../development/libraries/waylib { };

      wayqt = callPackage ../development/libraries/wayqt { };

      xwaylandvideobridge = kdePackages.callPackage ../tools/wayland/xwaylandvideobridge { };
    }
  );
}
