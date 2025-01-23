{
  mkKdeDerivation,
  qtbase,
  qtwayland,
  libsForQt5,
  xorg,
}:
mkKdeDerivation {
  pname = "plasma-integration";

  # force it to check our custom import path too
  patches = [ ./qml-path.patch ];

  outputs = [
    "out"
    "dev"
    "qt5"
  ];

  # We can't add qt5 stuff to dependencies or the hooks blow up,
  # so manually point everything to everything. Oof.
  extraCmakeFlags = [
    "-DQt5_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5"
    "-DQt5Concurrent_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Concurrent"
    "-DQt5Core_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Core"
    "-DQt5DBus_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5DBus"
    "-DQt5Gui_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Gui"
    "-DQt5Network_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Network"
    "-DQt5Qml_DIR=${libsForQt5.qtdeclarative.dev}/lib/cmake/Qt5Qml"
    "-DQt5QmlModels_DIR=${libsForQt5.qtdeclarative.dev}/lib/cmake/Qt5QmlModels"
    "-DQt5Quick_DIR=${libsForQt5.qtdeclarative.dev}/lib/cmake/Qt5Quick"
    "-DQt5QuickControls2_DIR=${libsForQt5.qtquickcontrols2.dev}/lib/cmake/Qt5QuickControls2"
    "-DQt5ThemeSupport_LIBRARY=${libsForQt5.qtbase.out}/lib/libQt5ThemeSupport.a"
    "-DQt5ThemeSupport_INCLUDE_DIR=${libsForQt5.qtbase.dev}/include/QtThemeSupport/${libsForQt5.qtbase.version}"
    "-DQt5WaylandClient_DIR=${libsForQt5.qtwayland.dev}/lib/cmake/Qt5WaylandClient"
    "-DQt5WaylandScanner_EXECUTABLE=${libsForQt5.qtwayland.dev}/bin/qtwaylandscanner"
    "-DQt5Widgets_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Widgets"
    "-DQt5X11Extras_DIR=${libsForQt5.qtx11extras.dev}/lib/cmake/Qt5X11Extras"
    "-DQt5Xml_DIR=${libsForQt5.qtbase.dev}/lib/cmake/Qt5Xml"
    "-DQtWaylandScanner_EXECUTABLE=${libsForQt5.qtwayland.dev}/bin/qtwaylandscanner"

    "-DKF5Auth_DIR=${libsForQt5.kauth.dev}/lib/cmake/KF5Auth"
    "-DKF5Bookmarks_DIR=${libsForQt5.kbookmarks.dev}/lib/cmake/KF5Bookmarks"
    "-DKF5Codecs_DIR=${libsForQt5.kcodecs.dev}/lib/cmake/KF5Codecs"
    "-DKF5Completion_DIR=${libsForQt5.kcompletion.dev}/lib/cmake/KF5Completion"
    "-DKF5Config_DIR=${libsForQt5.kconfig.dev}/lib/cmake/KF5Config"
    "-DKF5ConfigWidgets_DIR=${libsForQt5.kconfigwidgets.dev}/lib/cmake/KF5ConfigWidgets"
    "-DKF5CoreAddons_DIR=${libsForQt5.kcoreaddons.dev}/lib/cmake/KF5CoreAddons"
    "-DKF5GuiAddons_DIR=${libsForQt5.kguiaddons.dev}/lib/cmake/KF5GuiAddons"
    "-DKF5I18n_DIR=${libsForQt5.ki18n.dev}/lib/cmake/KF5I18n"
    "-DKF5IconThemes_DIR=${libsForQt5.kiconthemes.dev}/lib/cmake/KF5IconThemes"
    "-DKF5ItemViews_DIR=${libsForQt5.kitemviews.dev}/lib/cmake/KF5ItemViews"
    "-DKF5JobWidgets_DIR=${libsForQt5.kjobwidgets.dev}/lib/cmake/KF5JobWidgets"
    "-DKF5KIO_DIR=${libsForQt5.kio.dev}/lib/cmake/KF5KIO"
    "-DKF5Notifications_DIR=${libsForQt5.knotifications.dev}/lib/cmake/KF5Notifications"
    "-DKF5Service_DIR=${libsForQt5.kservice.dev}/lib/cmake/KF5Service"
    "-DKF5Solid_DIR=${libsForQt5.solid.dev}/lib/cmake/KF5Solid"
    "-DKF5Wayland_DIR=${libsForQt5.kwayland.dev}/lib/cmake/KF5Wayland"
    "-DKF5WidgetsAddons_DIR=${libsForQt5.kwidgetsaddons.dev}/lib/cmake/KF5WidgetsAddons"
    "-DKF5WindowSystem_DIR=${libsForQt5.kwindowsystem.dev}/lib/cmake/KF5WindowSystem"
    "-DKF5XmlGui_DIR=${libsForQt5.kxmlgui.dev}/lib/cmake/KF5XmlGui"
  ];

  extraBuildInputs = [
    qtwayland
    xorg.libXcursor
  ];

  # Move Qt5 plugin to Qt5 plugin path
  postInstall = ''
    mkdir -p $qt5/${libsForQt5.qtbase.qtPluginPrefix}/platformthemes
    mv $out/${qtbase.qtPluginPrefix}/platformthemes/KDEPlasmaPlatformTheme5.so $qt5/${libsForQt5.qtbase.qtPluginPrefix}/platformthemes
  '';
}
