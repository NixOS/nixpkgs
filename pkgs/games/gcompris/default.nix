{ mkDerivation
, cmake
, fetchurl
, gettext
, gst_all_1
, lib
, ninja
, qmlbox2d
, qtbase
, qtdeclarative
, qtgraphicaleffects
, qtmultimedia
, qtquickcontrols
, qtsensors
, qttools
, qtxmlpatterns
}:

mkDerivation rec {
  pname = "gcompris";
  version = "2.4";

  src = fetchurl {
    url = "https://download.kde.org/stable/gcompris/qt/src/gcompris-qt-${version}.tar.xz";
    sha256 = "sha256-/QZub48rarVHcD0PgOPc6NTlOKrsEzVK/qjHb5CjWS0=";
  };

  cmakeFlags = [
    "-DQML_BOX2D_LIBRARY=${qmlbox2d}/${qtbase.qtQmlPrefix}/Box2D.2.1"
  ];

  nativeBuildInputs = [ cmake gettext ninja qttools ];

  buildInputs = [
    qmlbox2d
    qtdeclarative
    qtgraphicaleffects
    qtmultimedia
    qtquickcontrols
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
