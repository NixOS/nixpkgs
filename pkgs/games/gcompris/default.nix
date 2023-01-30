{ stdenv
, cmake
, fetchurl
, gettext
, gst_all_1
, lib
, ninja
, wrapQtAppsHook
, qmlbox2d
, qtbase
, qtcharts
, qtdeclarative
, qtgraphicaleffects
, qtmultimedia
, qtquickcontrols2
, qtsensors
, qttools
, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  pname = "gcompris";
  version = "3.1";

  src = fetchurl {
    url = "https://download.kde.org/stable/gcompris/qt/src/gcompris-qt-${version}.tar.xz";
    hash = "sha256-wABGojMfiMgjUT5gVDfB5JmXK1SPkrIkqLT/403zUFI=";
  };

  cmakeFlags = [
    "-DQML_BOX2D_LIBRARY=${qmlbox2d}/${qtbase.qtQmlPrefix}/Box2D.2.1"
  ];

  nativeBuildInputs = [ cmake gettext ninja qttools wrapQtAppsHook ];

  buildInputs = [
    qmlbox2d
    qtbase
    qtcharts
    qtdeclarative
    qtgraphicaleffects
    qtmultimedia
    qtquickcontrols2
    qtsensors
    qtxmlpatterns
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  postInstall = ''
    install -Dm444 ../org.kde.gcompris.desktop     -t $out/share/applications
    install -Dm444 ../org.kde.gcompris.appdata.xml -t $out/share/metainfo
    install -Dm444 ../images/256-apps-gcompris-qt.png $out/share/icons/hicolor/256x256/apps/gcompris-qt.png

    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "A high quality educational software suite, including a large number of activities for children aged 2 to 10";
    homepage = "https://gcompris.net/";
    license = licenses.gpl3Plus;
    mainProgram = "gcompris-qt";
    maintainers = with maintainers; [ guibou ];
    platforms = platforms.linux;
  };
}
