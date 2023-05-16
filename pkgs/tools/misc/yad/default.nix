{ lib, stdenv, fetchFromGitHub, pkg-config, intltool, autoreconfHook, wrapGAppsHook
, gtk3, hicolor-icon-theme, netpbm }:

stdenv.mkDerivation rec {
  pname = "yad";
<<<<<<< HEAD
  version = "13.0";
=======
  version = "12.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "v1cont";
    repo = "yad";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-iYAhiaGfC9/OQ5HrSjX2fhpbwdZun6sxyw8o+8svcvY=";
=======
    sha256 = "sha256-VaeA83Wk5N3uLf8Eb606w3KPwV/3be5D39wW2JuSdp0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  configureFlags = [
    "--enable-icon-browser"
    "--with-gtk=gtk3"
    "--with-rgb=${placeholder "out"}/share/yad/rgb.txt"
  ];

  buildInputs = [ gtk3 hicolor-icon-theme ];

  nativeBuildInputs = [ autoreconfHook pkg-config intltool wrapGAppsHook ];

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
    maintainers = with maintainers; [ smironov ];
    platforms = with platforms; linux;
  };
}
