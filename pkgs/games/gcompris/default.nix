{stdenv, cmake, qtbase, fetchurl, qtdeclarative, qtmultimedia, qttools, qtsensors, qmlbox2d, gettext, qtquickcontrols, qtgraphicaleffects, makeWrapper,
  gst_all_1, ninja
}:
stdenv.mkDerivation rec {
  version = "0.95";
  name = "gcompris-${version}";

  src = fetchurl {
    url = "http://gcompris.net/download/qt/src/gcompris-qt-${version}.tar.xz";
    sha256 = "1aaijjx2b7k1cyx59jhs64hlp1sppw1faa81qxl5lxc79vifrlrl";
  };

  cmakeFlags = "-DQML_BOX2D_LIBRARY=${qmlbox2d}/${qtbase.qtQmlPrefix}/Box2D.2.0";

  nativeBuildInputs = [ cmake ninja makeWrapper ];
  buildInputs = [ qtbase qtdeclarative qttools qtsensors qmlbox2d gettext qtquickcontrols qtmultimedia qtgraphicaleffects] ++ soundPlugins;
  soundPlugins = with gst_all_1; [gst-plugins-good gstreamer gst-plugins-base gst-plugins-bad];

  postInstall = ''
    # install .desktop and icon file
    mkdir -p $out/share/applications/
    mkdir -p $out/share/icons/hicolor/256x256/apps/
    cp ../org.kde.gcompris.desktop $out/share/applications/gcompris.desktop
    cp -r ../images/256-apps-gcompris-qt.png $out/share/icons/hicolor/256x256/apps/gcompris-qt.png

    wrapProgram "$out/bin/gcompris-qt" \
       --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    '';

  meta = with stdenv.lib; {
    description = "A high quality educational software suite, including a large number of activities for children aged 2 to 10";
    homepage = "https://gcompris.net/";
    maintainers = [ maintainers.guibou ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.gpl3Plus;
  };
}
