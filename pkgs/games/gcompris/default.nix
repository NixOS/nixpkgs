{ stdenv, fetchurl, cmake, makeWrapper, ninja
, qtbase, qtdeclarative, qtmultimedia, qttools, qtsensors, qmlbox2d, gettext, qtquickcontrols, qtgraphicaleffects
, gst_all_1 }:

stdenv.mkDerivation rec {
  version = "0.91";
  name = "gcompris-${version}";

  src = fetchurl {
    url = "http://gcompris.net/download/qt/src/gcompris-qt-${version}.tar.xz";
    sha256 = "09h098w9q79hnzla1pcpqlnnr6dbafm4q6zmdp7wlk11ym8n9kvg";
  };

  cmakeFlags = "-DQML_BOX2D_LIBRARY=${qmlbox2d}/${qtbase.qtQmlPrefix}/Box2D.2.0";

  nativeBuildInputs = [ cmake ninja makeWrapper ];

  buildInputs = [
    qtbase qtdeclarative qttools qtsensors qmlbox2d gettext qtquickcontrols qtmultimedia qtgraphicaleffects
  ] ++ (with gst_all_1; [ gst-plugins-good gstreamer gst-plugins-base gst-plugins-bad ]);

  postInstall = ''
    install -Dm644 ../org.kde.gcompris.desktop        $out/share/applications/gcompris.desktop
    install -Dm644 ../images/256-apps-gcompris-qt.png $out/share/icons/hicolor/256x256/apps/gcompris-qt.png

    wrapProgram "$out/bin/gcompris-qt" \
       --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    '';

  meta = with stdenv.lib; {
    description = "A high quality educational software suite, including a large number of activities for children aged 2 to 10";
    homepage = https://gcompris.net/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ guibou ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
