{ stdenv
, lib
, fetchFromGitHub
, libadwaita
, libgee
, libportal-gtk4
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook4
, desktop-file-utils
, glib
, gtk4
}:

stdenv.mkDerivation rec {
  pname = "haguichi";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ztefn";
    repo = "haguichi";
    rev = version;
    hash = "sha256-Rhag2P4GAO9qhcajwDHIkgzKZqNii/SgvFwCI6Kc8XE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
    desktop-file-utils # for update-desktop-database
    glib # for glib-compile-resources
    gtk4 # for gtk-update-icon-cache
  ];

  buildInputs = [
    libadwaita
    libgee
    libportal-gtk4
    glib
    gtk4
  ];

  postPatch = ''
    patchShebangs meson_post_install.py
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Graphical frontend for Hamachi on Linux";
    mainProgram = "haguichi";
    homepage = "https://haguichi.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
