{ stdenv, fetchurl, pkgconfig, cmake, intltool, gettext
, libxml2, enchant, isocodes, icu, libpthreadstubs
, pango, cairo, libxkbfile, libXau, libXdmcp, libxkbcommon
, dbus, gtk2, gtk3, qt4, kde5
}:

stdenv.mkDerivation rec {
  name = "fcitx-${version}";
  version = "4.2.9.1";

  src = fetchurl {
    url    = "http://download.fcitx-im.org/fcitx/${name}_dict.tar.xz";
    sha256 = "0xvcmm4yi7kagf55d0yl3ql5ssbkm9410fwbz3kd988pchichdsk";
  };

  postUnpack = ''
    ln -s ${kde5.extra-cmake-modules}/share/ECM/modules/ECMFindModuleHelpers.cmake \
      $sourceRoot/cmake/
  '';

  patches = [ ./fcitx-ecm.patch ];

  postPatch = ''
    substituteInPlace src/frontend/qt/CMakeLists.txt \
      --replace $\{QT_PLUGINS_DIR} $out/lib/qt4/plugins
  '';

  buildInputs = [
    cmake enchant gettext isocodes pkgconfig intltool icu
    libpthreadstubs libXau libXdmcp libxkbfile libxkbcommon libxml2
    dbus cairo gtk2 gtk3 pango qt4
  ];

  cmakeFlags = ''
    -DENABLE_QT_IM_MODULE=ON
    -DENABLE_GTK2_IM_MODULE=ON
    -DENABLE_GTK3_IM_MODULE=ON
    -DENABLE_GIR=OFF
    -DENABLE_OPENCC=OFF
    -DENABLE_PRESAGE=OFF
    -DENABLE_XDGAUTOSTART=OFF
  '';

  meta = with stdenv.lib; {
    homepage    = "https://github.com/fcitx/fcitx";
    description = "A Flexible Input Method Framework";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
