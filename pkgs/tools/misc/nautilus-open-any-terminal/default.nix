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
, wrapGAppsHook3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "nautilus-open-any-terminal";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stunkymonkey";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-liyzgbZGl08gHLVpsy8NbTiTytNdiMdymF70ik4cPXs=";
  };

  patches = [ ./hardcode-gsettings.patch ];

  nativeBuildInputs = [
    glib
    gobject-introspection
    pkg-config
    wrapGAppsHook3
    python3.pkgs.setuptools
  ];

  buildInputs = [
    dbus
    dconf
    gnome.nautilus
    gnome.nautilus-python
    gsettings-desktop-schemas
    gtk3
    python3.pkgs.pygobject3
  ];

  postPatch = ''
    substituteInPlace nautilus_open_any_terminal/nautilus_open_any_terminal.py \
      --subst-var-by gsettings_path ${glib.makeSchemaPath "$out" "$name"}
  '';

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  meta = with lib; {
    description = "Extension for nautilus, which adds an context-entry for opening other terminal-emulators then `gnome-terminal`";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ stunkymonkey ];
    homepage = "https://github.com/Stunkymonkey/nautilus-open-any-terminal";
    platforms = platforms.linux;
  };
}
