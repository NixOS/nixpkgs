{
  mkKdeDerivation,
  qtbase,
  qtsvg,
  libsForQt5,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "breeze";

  # Backport fixes for Qt 6.9
  # FIXME: remove in 6.3.5 / 6.4
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/plasma/breeze/-/commit/098ad3facb3d76fe4476424f1b7bf3c9c2c1b142.patch";
      hash = "sha256-o9XrhYJIvygZ6nfcDKL22jxP7eaHeN3RGBixiOZh9O8=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/plasma/breeze/-/commit/e2f16562b64c63b623def44476eadc635a82c7de.patch";
      hash = "sha256-hPbLEfD3mhPfpoDfVUolUZ4+Pip5VNj8di/0ZDj7Jzw=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "qt5"
  ];

  extraBuildInputs = [ qtsvg ];

  # We can't add qt5 stuff to dependencies or the hooks blow up,
  # so manually point everything to everything. Oof.
  extraCmakeFlags = [
    "-DQt5_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5"
    "-DQt5Core_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Core"
    "-DQt5DBus_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5DBus"
    "-DQt5Gui_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Gui"
    "-DQt5Network_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Network"
    "-DQt5Qml_DIR=${libsForQt5.qtdeclarative.dev}/lib/cmake/Qt5Qml"
    "-DQt5QmlModels_DIR=${libsForQt5.qtdeclarative.dev}/lib/cmake/Qt5QmlModels"
    "-DQt5Quick_DIR=${libsForQt5.qtdeclarative.dev}/lib/cmake/Qt5Quick"
    "-DQt5Widgets_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Widgets"
    "-DQt5X11Extras_DIR=${libsForQt5.qtx11extras.dev}/lib/cmake/Qt5X11Extras"
    "-DQt5Xml_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Xml"

    "-DKF5Auth_DIR=${libsForQt5.kauth.dev}/lib/cmake/KF5Auth"
    "-DKF5Codecs_DIR=${libsForQt5.kcodecs.dev}/lib/cmake/KF5Codecs"
    "-DKF5Config_DIR=${libsForQt5.kconfig.dev}/lib/cmake/KF5Config"
    "-DKF5ConfigWidgets_DIR=${libsForQt5.kconfigwidgets.dev}/lib/cmake/KF5ConfigWidgets"
    "-DKF5CoreAddons_DIR=${libsForQt5.kcoreaddons.dev}/lib/cmake/KF5CoreAddons"
    "-DKF5FrameworkIntegration_DIR=${libsForQt5.frameworkintegration.dev}/lib/cmake/KF5FrameworkIntegration"
    "-DKF5GuiAddons_DIR=${libsForQt5.kguiaddons.dev}/lib/cmake/KF5GuiAddons"
    "-DKF5IconThemes_DIR=${libsForQt5.kiconthemes.dev}/lib/cmake/KF5IconThemes"
    "-DKF5Kirigami2_DIR=${libsForQt5.kirigami2.dev}/lib/cmake/KF5Kirigami2"
    "-DKF5WidgetsAddons_DIR=${libsForQt5.kwidgetsaddons.dev}/lib/cmake/KF5WidgetsAddons"
    "-DKF5WindowSystem_DIR=${libsForQt5.kwindowsystem.dev}/lib/cmake/KF5WindowSystem"
  ];

  # Move Qt5 plugin to Qt5 plugin path
  postInstall = ''
    mkdir -p $qt5/${libsForQt5.qtbase.qtPluginPrefix}/styles
    mv $out/${qtbase.qtPluginPrefix}/styles/breeze5.so $qt5/${libsForQt5.qtbase.qtPluginPrefix}/styles
  '';
  meta.mainProgram = "breeze-settings6";
}
