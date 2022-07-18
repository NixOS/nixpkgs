{ lib
, pkg-config
, dbus
, dconf
, fetchFromGitHub
, glib
, gnome
, gobject-introspection
, gsettings-desktop-schemas
, gtk3
, python3
, substituteAll
, wrapGAppsHook
}:

python3.pkgs.buildPythonPackage rec {
  pname = "nautilus-open-any-terminal";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Stunkymonkey";
    repo = pname;
    rev = version;
    sha256 = "sha256-PF6DVpiAPL9NG4jK6wDqdqYw+26Nks/bGEbbaV/5aIs=";
  };

  patches = [ ./hardcode-gsettings.patch ];

  nativeBuildInputs = [
    glib
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
    dconf
    gnome.nautilus
    gnome.nautilus-python
    gobject-introspection
    gsettings-desktop-schemas
    gtk3
    python3.pkgs.pygobject3
  ];

  postPatch = ''
    substituteInPlace nautilus_open_any_terminal/open_any_terminal_extension.py \
      --subst-var-by gsettings_path ${glib.makeSchemaPath "$out" "$name"}
  '';

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-3.0";

  meta = with lib; {
    description = "Extension for nautilus, which adds an context-entry for opening other terminal-emulators then `gnome-terminal`";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ stunkymonkey ];
    homepage = "https://github.com/Stunkymonkey/nautilus-open-any-terminal";
    platforms = platforms.linux;
  };
}
