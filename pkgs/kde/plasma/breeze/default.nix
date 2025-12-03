{
  mkKdeDerivation,
  qtbase,
  qtsvg,
  libsForQt5,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "breeze";

  # Fix extra thicc padding on menu items
  # FIXME: remove in next update
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/plasma/breeze/-/commit/4a8a46aba6b9e39bfb02c7f46933079b5a50eff5.diff";
      hash = "sha256-ZzRMMwz3OihChywzQWBNv9rPcZI+IcXNVzoRuXTWt9c=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/plasma/breeze/-/commit/2cd5b37dad8f213aab4029b6d3b80ca7f159ea50.diff";
      hash = "sha256-3pOJEH1H3o+U40K/mtKnruPsoA+vy+HrAa8vU5Oza6c=";
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
