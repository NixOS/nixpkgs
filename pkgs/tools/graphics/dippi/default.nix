{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, vala
, glib
, gtk3
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "dippi";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "dippi";
    rev = version;
    hash = "sha256-OYeSPh3m3udmGbIKoithCdsqWSAFnRhnAtQ0nTzFxzs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    # For post_install.py
    python3
    glib
    gtk3
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  postPatch = ''
    patchShebangs build-aux/meson/post_install.py
  '';

  postInstall = ''
    ln -s $out/bin/com.github.cassidyjames.dippi $out/bin/dippi
  '';

  meta = with lib; {
    description = "Calculate display info like DPI and aspect ratio";
    homepage = "https://github.com/cassidyjames/dippi";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
