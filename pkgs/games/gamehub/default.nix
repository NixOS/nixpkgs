{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  desktop-file-utils,
  glib,
  gtk3,
  glib-networking,
  libgee,
  libsoup,
  json-glib,
  sqlite,
  webkitgtk,
  libmanette,
  libXtst,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "GameHub";
  version = "0.16.3-2";

  src = fetchFromGitHub {
    owner = "tkashkin";
    repo = pname;
    rev = "${version}-master";
    hash = "sha256-dBGzXwDO9BvnEIcdfqlGnMzUdBqaVA96Ds0fY6eukes=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    glib-networking
    gtk3
    json-glib
    libgee
    libmanette
    libsoup
    libXtst
    sqlite
    webkitgtk
  ];

  meta = with lib; {
    homepage = "https://tkashkin.github.io/projects/gamehub";
    description = "Unified library for all your games";
    longDescription = ''
      GameHub is a unified library for all your games. It allows you to store
      your games from different platforms into one program to make it easier
      for you to manage your games.
    '';
    maintainers = with maintainers; [ pasqui23 ];
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
  };
}
