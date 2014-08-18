{ stdenv, fetchurl, pkgconfig, cmake, intltool, gettext
, libxml2, enchant, isocodes, icu, libpthreadstubs
, pango, cairo, libxkbfile, libXau, libXdmcp
}:

stdenv.mkDerivation rec {
  name = "fcitx-4.2.8.3";
  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx/${name}_dict.tar.xz";
    sha256 = "05dw6cbjh2jyjrkr4qx2bcq6nyhhrs0akf6fcjk5a72bgphhwqnb";
  };

  buildInputs = [
    cmake enchant pango gettext libxml2 isocodes pkgconfig libxkbfile
    intltool cairo icu libpthreadstubs libXau libXdmcp
  ];

  cmakeFlags = ''
    -DENABLE_DBUS=OFF
    -DENABLE_QT=OFF
    -DENABLE_QT_IM_MODULE=OFF
    -DENABLE_OPENCC=OFF
    -DENABLE_PRESAGE=OFF
    -DENABLE_XDGAUTOSTART=OFF
  '';

  meta = {
    homepage = "https://code.google.com/p/fcitx/";
    description = "A Flexible Input Method Framework";
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [iyzsong];
  };
}
