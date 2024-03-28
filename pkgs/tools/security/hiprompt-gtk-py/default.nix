{ lib
, stdenv
, fetchFromSourcehut
, desktop-file-utils
, glib
, gobject-introspection
, gtk3
, gtk-layer-shell
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "hiprompt-gtk-py";
  version = "unstable-2022-06-17";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~sircmpwn";
    repo = pname;
    rev = "f74499302bdd6558d4644c25e15c9b5c482270ea";
    hash = "sha256-/vYg7q4ZVakJ0BeULxJWXnBYb75tkgVVXbHYwnN6dZ4=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gobject-introspection
    gtk3
    gtk-layer-shell
    (python3.withPackages (pp: with pp; [
      pygobject3
    ]))
  ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hiprompt-gtk-py";
    description = "A GTK+ Himitsu prompter for Wayland";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ auchter ];
    platforms = platforms.linux;
  };
}
