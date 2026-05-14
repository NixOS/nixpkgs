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
  pkgsHostTarget,
}:

let
  pkgs = __splicedPackages;
  # qt5 set should not be pre-spliced to prevent spliced packages being a part of an unspliced set
  # 'pkgsCross.aarch64-multiplatform.pkgsBuildTarget.targetPackages.libsForQt5.qtbase' should not have a `__spliced` but if qt5 is pre-spliced then it will have one.
  # pkgsHostTarget == pkgs
  qt5 = pkgsHostTarget.qt5;
in

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "libsForQt5";
  f = (
    self:
    let
      libsForQt5 = self;
      callPackage = self.callPackage;

      kdeFrameworks =
        let
          mkFrameworks = import ../development/libraries/kde-frameworks;
          attrs = {
            inherit config;
            inherit libsForQt5;
            inherit (pkgs) lib fetchurl kdePackages;
          };
        in
        (lib.makeOverridable mkFrameworks attrs);

      noExtraAttrs =
        set:
        lib.attrsets.removeAttrs set [
          "extend"
          "override"
          "overrideScope"
          "overrideDerivation"
        ];

    in
    (noExtraAttrs (
      qt5
      // {

        inherit
          qt5
          ;

        __internalKF5 = lib.dontRecurseIntoAttrs kdeFrameworks;

        ### LIBRARIES

        accounts-qml-module = callPackage ../development/libraries/accounts-qml-module { };

        accounts-qt = callPackage ../development/libraries/accounts-qt { };

        dxflib = callPackage ../development/libraries/dxflib { };

        drumstick = callPackage ../development/libraries/drumstick { };

        fcitx5-qt = callPackage ../tools/inputmethods/fcitx5/fcitx5-qt.nix { };

        qgpgme = callPackage ../development/libraries/qgpgme { };

        grantlee = callPackage ../development/libraries/grantlee/5 { };

        herqq = callPackage ../development/libraries/herqq { };

        kcolorpicker = callPackage ../development/libraries/kcolorpicker { };

        kdsoap = callPackage ../development/libraries/kdsoap { };

        kimageannotator = callPackage ../development/libraries/kimageannotator { };

        ldutils = callPackage ../development/libraries/ldutils { };

        libcommuni = callPackage ../development/libraries/libcommuni { };

        libiodata = callPackage ../development/libraries/libiodata { };

        liblastfm = callPackage ../development/libraries/liblastfm { };

        libqglviewer = callPackage ../development/libraries/libqglviewer { };

        libqofono = callPackage ../development/libraries/libqofono { };

        libqtdbusmock = callPackage ../development/libraries/libqtdbusmock {
          inherit (pkgs.lomiri) cmake-extras;
        };

        libqtdbustest = callPackage ../development/libraries/libqtdbustest {
          inherit (pkgs.lomiri) cmake-extras;
        };

        libqtpas = callPackage ../development/compilers/fpc/libqtpas.nix { };

        mapbox-gl-qml = libsForQt5.callPackage ../development/libraries/mapbox-gl-qml { };

        maplibre-native-qt = callPackage ../development/libraries/maplibre-native-qt { };

        mlt = pkgs.mlt.override {
          qt = qt5;
        };

        polkit-qt = callPackage ../development/libraries/polkit-qt-1 { };

        poppler = callPackage ../development/libraries/poppler {
          lcms = pkgs.lcms2;
          qt5Support = true;
          suffix = "qt5";
        };

        pyotherside = callPackage ../development/libraries/pyotherside { };

        qca = callPackage ../development/libraries/qca {
          inherit (libsForQt5) qtbase;
        };
        qca-qt5 = self.qca;

        qcoro = callPackage ../development/libraries/qcoro { };

        qcustomplot = callPackage ../development/libraries/qcustomplot { };

        qjson = callPackage ../development/libraries/qjson { };

        qmenumodel = callPackage ../development/libraries/qmenumodel {
          inherit (pkgs.lomiri) cmake-extras;
        };

        qmltermwidget = callPackage ../development/libraries/qmltermwidget { };

        qoauth = callPackage ../development/libraries/qoauth { };

        qt5ct = callPackage ../tools/misc/qt5ct { };

        qtdbusextended = callPackage ../development/libraries/qtdbusextended { };

        qtfeedback = callPackage ../development/libraries/qtfeedback { };

        qtforkawesome = callPackage ../development/libraries/qtforkawesome { };

        qtutilities = callPackage ../development/libraries/qtutilities { };

        qtinstaller = callPackage ../development/libraries/qtinstaller { };

        qtkeychain = callPackage ../development/libraries/qtkeychain { };

        qtmpris = callPackage ../development/libraries/qtmpris { };

        qtpbfimageplugin = callPackage ../development/libraries/qtpbfimageplugin { };

        qtstyleplugins = callPackage ../development/libraries/qtstyleplugins { };

        qtstyleplugin-kvantum = callPackage ../development/libraries/qtstyleplugin-kvantum {
          qt6Kvantum = pkgs.qt6Packages.qtstyleplugin-kvantum;
        };

        quazip = callPackage ../development/libraries/quazip { };

        quickflux = callPackage ../development/libraries/quickflux { };

        qscintilla = callPackage ../development/libraries/qscintilla { };

        qwt = callPackage ../development/libraries/qwt/default.nix { };

        qwt6_1 = callPackage ../development/libraries/qwt/6_1.nix { };

        qxlsx = callPackage ../development/libraries/qxlsx { };

        qzxing = callPackage ../development/libraries/qzxing { };

        rlottie-qml = callPackage ../development/libraries/rlottie-qml { };

        sailfish-access-control-plugin =
          callPackage ../development/libraries/sailfish-access-control-plugin
            { };

        telepathy = callPackage ../development/libraries/telepathy/qt { };

        signond = callPackage ../development/libraries/signond { };

        timed = callPackage ../applications/system/timed { };

        xp-pen-deco-01-v2-driver = callPackage ../os-specific/linux/xp-pen-drivers/deco-01-v2 { };
      }
      // lib.optionalAttrs config.allowAliases {
        futuresql = throw "libsForQt5.futuresql has been removed"; # Added 2026-05-01
        kdb = throw "libsForQt5.kdb has been removed"; # Added 2026-05-01
        kdiagram = throw "libsForQt5.kdiagram has been removed"; # Added 2026-05-01
        kf5gpgmepp = throw ''
          'libsForQt5.kf5gpgmepp' has been removed because it has been unmaintained upstream since 2017.
          Consider switching to the gpgmepp included in gpgme (gpgme <2), or to the GnuPG fork of gpgmepp (gpgme 2+), instead.
        ''; # Added 2025-10-25
        kirigami-addons = throw "libsForQt5.kirigami-addons has been removed"; # Added 2026-05-01
        kproperty = throw "libsForQt5.kproperty has been removed"; # Added 2026-05-01
        kquickimageedit = throw "libsForQt5.kquickimageedit has been removed"; # Added 2026-05-01
        ktextaddons = throw "libsForQt5.ktextaddons has been removed"; # Added 2026-05-01
        kuserfeedback = throw "libsForQt5.kuserfeedback has been removed"; # Added 2026-05-01
        libqaccessibilityclient = throw "libsForQt5.libqaccessibilityclient has been removed"; # Added 2026-05-01
        mapbox-gl-native = throw "libsForQt5.mapbox-gl-native has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
        maplibre-gl-native = throw "libsForQt5.maplibre-gl-native has been removed due to being broken and superseded by maplibre-native-qt"; # Added 2026-04-11
        maui-core = throw "libsForQt5.maui-core has been removed"; # Added 2026-05-01
        phonon = throw "libsForQt5.phonon has been removed"; # Added 2026-05-01
        phonon-backend-gstreamer = throw "libsForQt5.phonon-backend-gstreamer has been removed"; # Added 2026-05-01
        phonon-backend-vlc = throw "libsForQt5.phonon-backend-vlc has been removed"; # Added 2026-05-01
        plasma-wayland-protocols = throw "libsForQt5.plasma-wayland-protocols has been removed"; # Added 2026-05-01
        pulseaudio-qt = throw "libsForQt5.pulseaudio-qt has been removed";
      }
    ))
  );
}
