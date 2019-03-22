{ stdenv, meson, ninja, pkgconfig, gettext, fetchFromGitHub, python3
, wrapGAppsHook, gtk3, glib, desktop-file-utils, appstream-glib, gnome3
, gobject-introspection }:

python3.pkgs.buildPythonApplication rec {
  pname = "piper";
  version = "0.2.903";

  format = "other";

  src = fetchFromGitHub {
    owner  = "libratbag";
    repo   = "piper";
    rev    =  version;
    sha256 = "0zh4lm074x5gwvx663bapdyv8lf84yjwfg8cpf77rszyja1hx13a";
  };

  nativeBuildInputs = [ meson ninja gettext pkgconfig wrapGAppsHook desktop-file-utils appstream-glib gobject-introspection ];
  buildInputs = [ gtk3 glib gnome3.adwaita-icon-theme python3 ];
  propagatedBuildInputs = with python3.pkgs; [ lxml evdev pygobject3 ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh
  '';

  meta = with stdenv.lib; {
    description = "GTK frontend for ratbagd mouse config daemon";
    homepage    = https://github.com/libratbag/piper;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms   = platforms.linux;
  };
}
