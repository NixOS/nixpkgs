{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, desktop-file-utils
, glib
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "haguichi";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "ztefn";
    repo = "haguichi";
    rev = version;
    hash = "sha256-H/Aw8zJOioOLWxiM/pMb+QSIoEp3zIkLb26S6QN3hv0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
    desktop-file-utils # for update-desktop-database
    glib # for glib-compile-resources
    gtk3 # for gtk-update-icon-cache
  ];

  buildInputs = [
    glib
    gtk3
  ];

  postPatch = ''
    patchShebangs meson_post_install.py
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Graphical frontend for Hamachi on Linux";
    homepage = "https://haguichi.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
