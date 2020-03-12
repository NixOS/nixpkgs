{ stdenv, fetchFromGitHub, pkgconfig, intltool, autoreconfHook, wrapGAppsHook
, gtk3, hicolor-icon-theme, netpbm }:

stdenv.mkDerivation rec {
  pname = "yad";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "v1cont";
    repo = "yad";
    rev = "v${version}";
    sha256 = "07rd61hvilsxxrj7lf8c9k0a8glj07s48m7ya8d45030r90g3lvc";
  };

  configureFlags = [
    "--enable-icon-browser"
    "--with-gtk=gtk3"
    "--with-rgb=${placeholder "out"}/share/yad/rgb.txt"
  ];

  buildInputs = [ gtk3 hicolor-icon-theme ];

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool wrapGAppsHook ];

  postPatch = ''
    sed -i src/file.c -e '21i#include <glib/gprintf.h>'
    sed -i src/form.c -e '21i#include <stdlib.h>'

    # there is no point to bring in the whole netpbm package just for this file
    install -Dm644 ${netpbm.out}/share/netpbm/misc/rgb.txt $out/share/yad/rgb.txt
  '';

  postAutoreconf = ''
    intltoolize
  '';

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/yad-dialog/;
    description = "GUI dialog tool for shell scripts";
    longDescription = ''
      Yad (yet another dialog) is a GUI dialog tool for shell scripts. It is a
      fork of Zenity with many improvements, such as custom buttons, additional
      dialogs, pop-up menu in notification icon and more.
    '';

    license = licenses.gpl3;
    maintainers = with maintainers; [ smironov ];
    platforms = with platforms; linux;
  };
}
