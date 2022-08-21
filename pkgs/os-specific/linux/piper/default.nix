{ lib, meson, ninja, pkg-config, gettext, fetchFromGitHub, python3
, wrapGAppsHook, gtk3, glib, desktop-file-utils, appstream-glib, gnome
, gobject-introspection, librsvg }:

python3.pkgs.buildPythonApplication rec {
  pname = "piper";
  version = "0.5.1";

  format = "other";

  src = fetchFromGitHub {
    owner  = "libratbag";
    repo   = "piper";
    rev    =  version;
    sha256 = "1nfjnsiwg2rs6gkjsxzhr2708i6di149dgwq3cf6l12rxqpb8arj";
  };

  nativeBuildInputs = [ meson ninja gettext pkg-config wrapGAppsHook desktop-file-utils appstream-glib gobject-introspection ];
  buildInputs = [
    gtk3 glib gnome.adwaita-icon-theme python3 librsvg
  ];
  propagatedBuildInputs = with python3.pkgs; [ lxml evdev pygobject3 ] ++ [
    gobject-introspection # fixes https://github.com/NixOS/nixpkgs/issues/56943 for now
  ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh
  '';

  meta = with lib; {
    description = "GTK frontend for ratbagd mouse config daemon";
    homepage    = "https://github.com/libratbag/piper";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms   = platforms.linux;
  };
}
