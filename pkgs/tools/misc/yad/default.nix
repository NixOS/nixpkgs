{ stdenv, fetchurl, pkgconfig, intltool, gtk2, hicolor-icon-theme
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "yad-0.40.0";

  src = fetchurl {
    url = "mirror://sourceforge/yad-dialog/files/${name}.tar.xz";
    sha256 = "1x0fsv8nfkm8lchdawnf3zw79jaqbnvhv87sk5r8g86knv8vgl62";
  };

  configureFlags = [
    "--enable-icon-browser"
  ];

  # for gcc5: c11 inline semantics breaks the build
  NIX_CFLAGS_COMPILE = "-fgnu89-inline";

  buildInputs = [ gtk2 hicolor-icon-theme ];

  nativeBuildInputs = [ pkgconfig intltool wrapGAppsHook ];

  postPatch = ''
    sed -i src/file.c -e '21i#include <glib/gprintf.h>'
    sed -i src/form.c -e '21i#include <stdlib.h>'
  '';

  meta = {
    homepage = https://sourceforge.net/projects/yad-dialog/;
    description = "GUI dialog tool for shell scripts";
    longDescription = ''
      Yad (yet another dialog) is a GUI dialog tool for shell scripts. It is a
      fork of Zenity with many improvements, such as custom buttons, additional
      dialogs, pop-up menu in notification icon and more.
    '';

    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ smironov ];
    license = stdenv.lib.licenses.gpl3;
  };
}

