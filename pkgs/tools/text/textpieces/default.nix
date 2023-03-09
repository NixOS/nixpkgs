{ lib
, stdenv
, fetchFromGitHub
, python3
, meson
, ninja
, pkg-config
, vala
, glib
, gtk4
, libgee
, libadwaita
, json-glib
, blueprint-compiler
, gtksourceview5
, gobject-introspection
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

let
  pythonEnv = python3.withPackages ( ps: with ps; [ pyyaml ] );
in
stdenv.mkDerivation rec {
  pname = "textpieces";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "liferooter";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LQq6pjue72a4kIHhWtoxJi/eKxPa4du5sBQY97SG1gY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    pythonEnv
    vala
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libgee
    json-glib
    gtksourceview5
    gobject-introspection
  ];

  runtimeDependencies = [
    pythonEnv
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
    patchShebangs scripts/
  '';

  meta = with lib; {
    description = "Quick text processing";
    longDescription = "A small tool for quick text transformations such as checksums, encoding, decoding and so on.";
    homepage = "https://github.com/liferooter/textpieces";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
