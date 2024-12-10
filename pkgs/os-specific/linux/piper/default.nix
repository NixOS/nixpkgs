{
  lib,
  meson,
  ninja,
  pkg-config,
  gettext,
  fetchFromGitHub,
  python3,
  wrapGAppsHook3,
  gtk3,
  glib,
  desktop-file-utils,
  appstream-glib,
  gnome,
  gobject-introspection,
  librsvg,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "piper";
  version = "0.7";

  format = "other";

  src = fetchFromGitHub {
    owner = "libratbag";
    repo = "piper";
    rev = version;
    sha256 = "0jsvfy0ihdcgnqljfgs41lys1nlz18qvsa0a8ndx3pyr41f8w8wf";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook3
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];
  buildInputs = [
    gtk3
    glib
    gnome.adwaita-icon-theme
    python3
    librsvg
  ];
  propagatedBuildInputs = with python3.pkgs; [
    lxml
    evdev
    pygobject3
  ];

  mesonFlags = [
    "-Druntime-dependency-checks=false"
    "-Dtests=false"
  ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh data/generate-piper-gresource.xml.py
  '';

  meta = with lib; {
    description = "GTK frontend for ratbagd mouse config daemon";
    mainProgram = "piper";
    homepage = "https://github.com/libratbag/piper";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
