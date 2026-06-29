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
  # Allow to override qt6 packages used within
  qt6,
  kdePackages,
}:

let
  pkgs = __splicedPackages;
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
      accounts-qml-module = callPackage ../development/libraries/accounts-qml-module { };
      accounts-qt = callPackage ../development/libraries/accounts-qt { };
      appstream-qt = callPackage ../development/libraries/appstream/qt.nix { };

      drumstick = callPackage ../development/libraries/drumstick { };

      fcitx5-chinese-addons = callPackage ../tools/inputmethods/fcitx5/fcitx5-chinese-addons.nix { };

      fcitx5-configtool = kdePackages.callPackage ../tools/inputmethods/fcitx5/fcitx5-configtool.nix { };

      fcitx5-qt = callPackage ../tools/inputmethods/fcitx5/fcitx5-qt.nix { };

      fcitx5-skk-qt = pkgs.fcitx5-skk.override { enableQt = true; };

      fcitx5-unikey = callPackage ../tools/inputmethods/fcitx5/fcitx5-unikey.nix { };

      fcitx5-with-addons = callPackage ../tools/inputmethods/fcitx5/with-addons.nix { };

      kdsoap = callPackage ../development/libraries/kdsoap { };

      kcolorpicker = callPackage ../development/libraries/kcolorpicker { };
      kimageannotator = callPackage ../development/libraries/kimageannotator { };

      futuresql = callPackage ../development/libraries/futuresql { };
      kquickimageedit = callPackage ../development/libraries/kquickimageedit { };

      ktactilefeedback = kdePackages.callPackage ../development/libraries/ktactilefeedback { };

      libiodata = callPackage ../development/libraries/libiodata { };

      libqaccessibilityclient = callPackage ../development/libraries/libqaccessibilityclient { };

      libqglviewer = callPackage ../development/libraries/libqglviewer { };

      libqtpas = callPackage ../development/compilers/fpc/libqtpas.nix { };

      libqtdbusmock = callPackage ../development/libraries/libqtdbusmock {
        inherit (pkgs.lomiri-qt6) cmake-extras;
      };

      libqtdbustest = callPackage ../development/libraries/libqtdbustest {
        inherit (pkgs.lomiri-qt6) cmake-extras;
      };

      libquotient = callPackage ../development/libraries/libquotient { };
      mlt = callPackage ../by-name/ml/mlt/package.nix { };

      maplibre-native-qt = callPackage ../development/libraries/maplibre-native-qt { };

      pyotherside = callPackage ../development/libraries/pyotherside { };

      qca = callPackage ../development/libraries/qca { };
      qcoro = callPackage ../development/libraries/qcoro { };
      qcustomplot = callPackage ../development/libraries/qcustomplot { };
      qgpgme = callPackage ../development/libraries/qgpgme { };
      qhotkey = callPackage ../development/libraries/qhotkey { };
      qmlbox2d = callPackage ../development/libraries/qmlbox2d { };
      packagekit-qt = callPackage ../tools/package-management/packagekit/qt.nix { };

      qmenumodel = callPackage ../development/libraries/qmenumodel {
        inherit (pkgs.lomiri-qt6) cmake-extras;
      };

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

      sddm-unwrapped = kdePackages.callPackage ../applications/display-managers/sddm/unwrapped.nix { };
      sddm = kdePackages.callPackage ../applications/display-managers/sddm { };

      sierra-breeze-enhanced =
        kdePackages.callPackage ../data/themes/kwin-decorations/sierra-breeze-enhanced
          { };

      signond = callPackage ../development/libraries/signond { };

      timed = callPackage ../applications/system/timed { };

      wayqt = callPackage ../development/libraries/wayqt { };
    }
    // lib.optionalAttrs config.allowAliases {
      qwlroots = throw ''
        'qt6Packages.qwlroots' has been removed because it has been merged into treeland upstream.
        The upstream no longer provides it as a standalone development library.
      ''; # Added 2025-02-07
      waylib = throw ''
        'qt6Packages.waylib' has been removed because it has been merged into treeland upstream.
        The upstream no longer provides it as a standalone development library.
      ''; # Added 2025-02-07
    }
  );
}
