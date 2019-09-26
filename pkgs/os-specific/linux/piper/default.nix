{ stdenv, meson, ninja, pkgconfig, gettext, fetchFromGitHub, python3
, wrapGAppsHook, gtk3, glib, desktop-file-utils, appstream-glib, gnome3, pango
, gobject-introspection, libratbag }:

python3.pkgs.buildPythonApplication rec {
  pname = "piper";
  version = "0.3";

  format = "other";

  src = fetchFromGitHub {
    owner  = "libratbag";
    repo   = "piper";
    rev    =  version;
    sha256 = "1vz7blhx6qsfrk5znwr0fj1k8vahnlaz6rn7ifcgxmq398mmz8z7";
  };

  # gobject-introspection needs to be in both buildInputs and nativeBuildInputs
  # https://github.com/NixOS/nixpkgs/issues/56943#issuecomment-470600145
  nativeBuildInputs = [
    meson ninja gettext pkgconfig wrapGAppsHook desktop-file-utils appstream-glib gobject-introspection
  ];

  buildInputs = [
    gtk3 glib gnome3.adwaita-icon-theme libratbag pango python3 gobject-introspection
  ];

  propagatedBuildInputs = with python3.pkgs; [ lxml evdev pango pygobject3 ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh
    substituteInPlace meson.build \
      --replace "find_program('ratbagd'" "find_program('${libratbag}/bin/ratbagd'"
  '';

  meta = with stdenv.lib; {
    description = "GTK frontend for ratbagd mouse config daemon";
    homepage    = "https://github.com/libratbag/piper";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms   = platforms.linux;
  };
}
