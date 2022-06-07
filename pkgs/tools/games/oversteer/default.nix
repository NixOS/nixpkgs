{ lib, stdenv, meson, ninja, pkgconfig, gettext, cmake, udev, fetchFromGitHub, python3
, wrapGAppsHook, gtk3, glib, gnome3, appstream-glib, gobject-introspection, desktop-file-utils }:

python3.pkgs.buildPythonApplication rec {
  pname = "oversteer";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "berarma";
    repo = pname;
    rev = version;
    sha256 = "zugyB8QvnMdqXJf41oiR/beDLbK//FIPF5AcESSmKPc=";
  };

  format = "other";

  strictDeps = false;

  postPatch = ''
    mkdir -p $out/lib/udev/rules.d

    substituteInPlace meson.build \
      --replace "py_installation.get_path('purelib')" "'$out/'" \
      --replace "pkgdatadir + '/udev'" "'$out/lib/udev/rules.d'" \
      --replace "get_option('udev_rules_dir')" "'$out/lib/udev/rules.d'"
    substituteInPlace data/meson.build \
      --replace "udev_rules_dir" "'$out/lib/udev/rules.d'"
    sed -i '21,31d' meson.build

    chmod +x scripts/meson_post_install.py
    patchShebangs scripts/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkgconfig
    wrapGAppsHook
    desktop-file-utils
    appstream-glib
    gobject-introspection
    cmake
    udev
  ];

  buildInputs = [ udev gtk3 glib gnome3.adwaita-icon-theme python3 ];

  propagatedBuildInputs = with python3.pkgs; [ pyudev pyxdg evdev pygobject3 matplotlib scipy ];

  meta = with lib; {
    description = "Application to configure Logitech steering wheels on Linux";
    homepage = "https://github.com/berarma/oversteer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthiasbenaets ];
    platforms = platforms.linux;
  };
}
