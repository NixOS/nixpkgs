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
  version = "1.146.0";

  src = fetchFromGitHub {
    owner = "ztefn";
    repo = "haguichi";
    rev = version;
    sha256 = "sha256-606WZ8OEypBTCXZppA1h9tKvMm46DMnegnK4pNRkWBc=";
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

  meta = with lib; {
    description = "Graphical frontend for Hamachi on Linux";
    homepage = "https://haguichi.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
