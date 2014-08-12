{ stdenv, fetchurl, pkgconfig, cmake, intltool, gettext
, libxml2, enchant, isocodes, icu, libpthreadstubs
, pango, cairo, libxkbfile, libXau, libXdmcp
, dbus, gtk2, gtk3, qt4
}:

stdenv.mkDerivation rec {
  name = "fcitx-4.2.8.3";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx/${name}_dict.tar.xz";
    sha256 = "05dw6cbjh2jyjrkr4qx2bcq6nyhhrs0akf6fcjk5a72bgphhwqnb";
  };

  patchPhase = ''
    substituteInPlace src/frontend/qt/CMakeLists.txt \
      --replace $\{QT_PLUGINS_DIR} $out/lib/qt4/plugins
  '';

  buildInputs = with stdenv.lib; [
    cmake enchant pango gettext libxml2 isocodes pkgconfig libxkbfile
    intltool cairo icu libpthreadstubs libXau libXdmcp
    dbus gtk2 gtk3 qt4
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

  meta = {
    homepage = "https://code.google.com/p/fcitx/";
    description = "A Flexible Input Method Framework";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [iyzsong];
  };
}
