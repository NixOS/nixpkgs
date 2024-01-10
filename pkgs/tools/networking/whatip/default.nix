{ lib
, fetchFromGitLab
, python3
, meson
, ninja
, pkg-config
, glib
, gtk4
, libadwaita
, librsvg
, blueprint-compiler
, gobject-introspection
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "whatip";
  version = "1.2";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GabMus";
    repo = pname;
    rev = version;
    hash = "sha256-gt/NKgnCpRoVmLvEJJq2geng4miM2g+YhXYEOm5pPTA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libadwaita
  ];

  propagatedBuildInputs = with python3.pkgs; [
    netaddr
    requests
    pygobject3
  ];

  meta = with lib; {
    description = "Info on your IP";
    homepage = "https://gitlab.gnome.org/GabMus/whatip";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
