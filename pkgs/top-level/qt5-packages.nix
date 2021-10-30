
# Qt packages set.
#
# Attributes in this file are packages requiring Qt and will be made available
# for every Qt version. Qt applications are called from `all-packages.nix` via
# this file.


{ lib
, pkgs
, qt5
}:

(lib.makeScope pkgs.newScope ( self:

let
  libsForQt5 = self;
  callPackage = self.callPackage;

  kdeFrameworks = let
    mkFrameworks = import ../development/libraries/kde-frameworks;
    attrs = {
      inherit libsForQt5;
      inherit (pkgs) lib fetchurl;
    };
  in (lib.makeOverridable mkFrameworks attrs);

  plasma5 = let
    mkPlasma5 = import ../desktops/plasma-5;
    attrs = {
      inherit libsForQt5;
      inherit (pkgs) config lib fetchurl;
      gconf = pkgs.gnome2.GConf;
      inherit (pkgs) gsettings-desktop-schemas;
    };
  in (lib.makeOverridable mkPlasma5 attrs);

  kdeGear = let
    mkGear = import ../applications/kde;
    attrs = {
      inherit libsForQt5;
      inherit (pkgs) lib fetchurl;
    };
  in (lib.makeOverridable mkGear attrs);

  plasmaMobileGear = let
    mkPlamoGear = import ../applications/plasma-mobile;
    attrs = {
      inherit libsForQt5;
      inherit (pkgs) lib fetchurl;
    };
  in (lib.makeOverridable mkPlamoGear attrs);

in (kdeFrameworks // plasmaMobileGear // plasma5 // plasma5.thirdParty // kdeGear // qt5 // {

  inherit kdeFrameworks plasmaMobileGear plasma5 kdeGear qt5;

  # Alias for backwards compatibility. Added 2021-05-07.
  kdeApplications = kdeGear;

  ### LIBRARIES

  accounts-qt = callPackage ../development/libraries/accounts-qt { };

  alkimia = callPackage ../development/libraries/alkimia { };

  applet-window-buttons = callPackage ../development/libraries/applet-window-buttons { };

  appstream-qt = callPackage ../development/libraries/appstream/qt.nix { };

  dxflib = callPackage ../development/libraries/dxflib {};

  drumstick = callPackage ../development/libraries/drumstick { };

  fcitx-qt5 = callPackage ../tools/inputmethods/fcitx/fcitx-qt5.nix { };

  fcitx5-qt = callPackage ../tools/inputmethods/fcitx5/fcitx5-qt.nix { };

  qgpgme = callPackage ../development/libraries/gpgme { };

  grantlee = callPackage ../development/libraries/grantlee/5 { };

  qtcurve = callPackage ../data/themes/qtcurve {};

  herqq = callPackage ../development/libraries/herqq { };

  kdb = callPackage ../development/libraries/kdb { };

  kde2-decoration = callPackage ../data/themes/kde2 { };

  kcolorpicker = callPackage ../development/libraries/kcolorpicker { };

  kdiagram = callPackage ../development/libraries/kdiagram { };

  kdsoap = callPackage ../development/libraries/kdsoap { };

  kf5gpgmepp = callPackage ../development/libraries/kf5gpgmepp { };

  kirigami-addons = libsForQt5.callPackage ../development/libraries/kirigami-addons { };

  kimageannotator = callPackage ../development/libraries/kimageannotator { };

  kproperty = callPackage ../development/libraries/kproperty { };

  kpeoplevcard = callPackage ../development/libraries/kpeoplevcard { };

  kreport = callPackage ../development/libraries/kreport { };

  kquickimageedit = callPackage ../development/libraries/kquickimageedit { };

  kweathercore = libsForQt5.callPackage ../development/libraries/kweathercore { };

  ldutils = callPackage ../development/libraries/ldutils { };

  libcommuni = callPackage ../development/libraries/libcommuni { };

  libdbusmenu = callPackage ../development/libraries/libdbusmenu-qt/qt-5.5.nix { };

  libktorrent = callPackage ../development/libraries/libktorrent { };

  liblastfm = callPackage ../development/libraries/liblastfm { };

  libopenshot = callPackage ../applications/video/openshot-qt/libopenshot.nix { };

  packagekit-qt = callPackage ../tools/package-management/packagekit/qt.nix { };

  libopenshot-audio = callPackage ../applications/video/openshot-qt/libopenshot-audio.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) AGL Cocoa Foundation;
  };

  libqglviewer = callPackage ../development/libraries/libqglviewer {
    inherit (pkgs.darwin.apple_sdk.frameworks) AGL;
  };

  libqofono = callPackage ../development/libraries/libqofono { };

  libqtav = callPackage ../development/libraries/libqtav { };

  kpmcore = callPackage ../development/libraries/kpmcore { };

  mapbox-gl-native = libsForQt5.callPackage ../development/libraries/mapbox-gl-native { };

  mapbox-gl-qml = libsForQt5.callPackage ../development/libraries/mapbox-gl-qml { };

  mauikit = callPackage ../development/libraries/mauikit { };

  mauikit-filebrowsing = callPackage ../development/libraries/mauikit-filebrowsing { };

  mlt = callPackage ../development/libraries/mlt/qt-5.nix { };

  openbr = callPackage ../development/libraries/openbr { };

  phonon = callPackage ../development/libraries/phonon { };

  phonon-backend-gstreamer = callPackage ../development/libraries/phonon/backends/gstreamer.nix { };

  phonon-backend-vlc = callPackage ../development/libraries/phonon/backends/vlc.nix { };

  plasma-wayland-protocols = callPackage ../development/libraries/plasma-wayland-protocols { };

  polkit-qt = callPackage ../development/libraries/polkit-qt-1 { };

  poppler = callPackage ../development/libraries/poppler {
    lcms = pkgs.lcms2;
    qt5Support = true;
    suffix = "qt5";
  };

  poppler_0_61 = callPackage ../development/libraries/poppler/0.61.nix {
    lcms = pkgs.lcms2;
    qt5Support = true;
    suffix = "qt5";
  };

  pulseaudio-qt = callPackage ../development/libraries/pulseaudio-qt { };

  qca-qt5 = callPackage ../development/libraries/qca-qt5 { };

  qcoro = callPackage ../development/libraries/qcoro { };

  qcsxcad = callPackage ../development/libraries/science/electronics/qcsxcad { };

  qmltermwidget = callPackage ../development/libraries/qmltermwidget {
    inherit (pkgs.darwin.apple_sdk.libs) utmp;
  };

  qmlbox2d = callPackage ../development/libraries/qmlbox2d { };

  qoauth = callPackage ../development/libraries/qoauth { };

  qscintilla = callPackage ../development/libraries/qscintilla {
    withQt5 = true;
  };

  qtfeedback = callPackage ../development/libraries/qtfeedback { };

  qtutilities = callPackage ../development/libraries/qtutilities { };

  qtinstaller = callPackage ../development/libraries/qtinstaller { };

  qtkeychain = callPackage ../development/libraries/qtkeychain {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  qtpbfimageplugin = callPackage ../development/libraries/qtpbfimageplugin { };

  qtstyleplugins = callPackage ../development/libraries/qtstyleplugins { };

  qtstyleplugin-kvantum = callPackage ../development/libraries/qtstyleplugin-kvantum { };

  quazip = callPackage ../development/libraries/quazip { };

  qwt = callPackage ../development/libraries/qwt/6.nix { };

  soqt = callPackage ../development/libraries/soqt { };

  telepathy = callPackage ../development/libraries/telepathy/qt { };

  qtwebkit-plugins = callPackage ../development/libraries/qtwebkit-plugins { };

  # Not a library, but we do want it to be built for every qt version there
  # is, to allow users to choose the right build if needed.
  sddm = callPackage ../applications/display-managers/sddm { };

  signond = callPackage ../development/libraries/signond {};

  soundkonverter = callPackage ../applications/audio/soundkonverter {};

})))
