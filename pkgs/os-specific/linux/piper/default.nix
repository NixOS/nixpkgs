{ stdenv, meson, ninja, pkgconfig, gettext, fetchFromGitHub, python3
, wrapGAppsHook, gtk3, glib, desktop-file-utils, appstream-glib, gnome3
, gobject-introspection }:

python3.pkgs.buildPythonApplication rec {
  pname = "piper";
  version = "0.5";

  format = "other";

  src = fetchFromGitHub {
    owner  = "libratbag";
    repo   = "piper";
    rev    =  version;
    sha256 = "00vrcsbsv2477l1ncpyzc61lhxgac84dsgr3sjs8qxw3nh1gaasv";
  };

  nativeBuildInputs = [ meson ninja gettext pkgconfig wrapGAppsHook desktop-file-utils appstream-glib gobject-introspection ];
  buildInputs = [
    gtk3 glib gnome3.adwaita-icon-theme python3
  ];
  propagatedBuildInputs = with python3.pkgs; [ lxml evdev pygobject3 ] ++ [
    gobject-introspection # fixes https://github.com/NixOS/nixpkgs/issues/56943 for now
  ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh
  '';

  meta = with stdenv.lib; {
    description = "GTK frontend for ratbagd mouse config daemon";
    homepage    = "https://github.com/libratbag/piper";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms   = platforms.linux;
  };
}
