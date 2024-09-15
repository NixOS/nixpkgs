{ lib, stdenv, fetchFromGitHub, pkg-config, intltool, autoreconfHook, wrapGAppsHook3
, gtk3, hicolor-icon-theme, netpbm }:

stdenv.mkDerivation rec {
  pname = "yad";
  version = "14.1";

  src = fetchFromGitHub {
    owner = "v1cont";
    repo = "yad";
    rev = "v${version}";
    sha256 = "sha256-Y7bp20fkNdSgBcSV1kPEpWEP7ASwZcScVRaPauwI72M=";
  };

  configureFlags = [
    "--enable-icon-browser"
    "--with-gtk=gtk3"
    "--with-rgb=${placeholder "out"}/share/yad/rgb.txt"
  ];

  buildInputs = [ gtk3 hicolor-icon-theme ];

  nativeBuildInputs = [ autoreconfHook pkg-config intltool wrapGAppsHook3 ];

  postPatch = ''
    sed -i src/file.c -e '21i#include <glib/gprintf.h>'
    sed -i src/form.c -e '21i#include <stdlib.h>'

    # there is no point to bring in the whole netpbm package just for this file
    install -Dm644 ${netpbm.out}/share/netpbm/misc/rgb.txt $out/share/yad/rgb.txt
  '';

  postAutoreconf = ''
    intltoolize
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/yad-dialog/";
    description = "GUI dialog tool for shell scripts";
    longDescription = ''
      Yad (yet another dialog) is a GUI dialog tool for shell scripts. It is a
      fork of Zenity with many improvements, such as custom buttons, additional
      dialogs, pop-up menu in notification icon and more.
    '';

    license = licenses.gpl3;
    mainProgram = "yad";
    maintainers = with maintainers; [ smironov ];
    platforms = with platforms; linux;
  };
}
