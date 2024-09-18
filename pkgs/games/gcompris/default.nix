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
, qtimageformats
, qtmultimedia
, qtquickcontrols2
, qtsensors
, qttools
, qtxmlpatterns
, extra-cmake-modules
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcompris";
  version = "4.1";

  src = fetchurl {
    url = "mirror://kde/stable/gcompris/qt/src/gcompris-qt-${finalAttrs.version}.tar.xz";
    hash = "sha256-Pz0cOyBfiexKHUsHXm18Zw2FKu7b7vVuwy4Vu4daBoU=";
  };

  cmakeFlags = [
    (lib.cmakeFeature "QML_BOX2D_LIBRARY" "${qmlbox2d}/${qtbase.qtQmlPrefix}/Box2D.2.1")
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules gettext ninja qttools wrapQtAppsHook ];

  buildInputs = [
    qmlbox2d
    qtbase
    qtcharts
    qtdeclarative
    qtgraphicaleffects
    qtimageformats
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
    install -Dm444 ../org.kde.gcompris.appdata.xml -t $out/share/metainfo

    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  # we need a graphical environment for the tests
  doCheck = false;

  meta = with lib; {
    description = "High quality educational software suite, including a large number of activities for children aged 2 to 10";
    homepage = "https://gcompris.net/";
    license = licenses.gpl3Plus;
    mainProgram = "gcompris-qt";
    maintainers = with maintainers; [ guibou ];
    platforms = platforms.linux;
  };
})
