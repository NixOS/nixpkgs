{ stdenv, fetchurl, pkgconfig, cmake, intltool, gettext
, libxml2, enchant, isocodes, icu, libpthreadstubs
, pango, cairo, libxkbfile, xorg
}:

stdenv.mkDerivation rec {
  name = "fcitx-4.2.7";
  src = fetchurl {
    url = "https://fcitx.googlecode.com/files/${name}_dict.tar.xz";
    sha256 = "1dfvr77j9vnlg76155clrjxnm59r5fzv0d3n6c6yn10zb0bjd40c";
  };

  buildInputs = [
    cmake enchant pango gettext libxml2 isocodes pkgconfig libxkbfile
    intltool cairo icu libpthreadstubs xorg.libXau xorg.libXdmcp
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
  };
}
