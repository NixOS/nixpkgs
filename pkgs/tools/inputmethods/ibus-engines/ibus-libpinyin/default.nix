{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  pkg-config,
  wrapGAppsHook3,
  sqlite,
  libpinyin,
  db,
  ibus,
  glib,
  gtk3,
  python3,
  lua,
  opencc,
  libsoup_3,
  json-glib,
  libnotify,
}:

stdenv.mkDerivation rec {
  pname = "ibus-libpinyin";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    tag = version;
    hash = "sha256-aeyoBfl5x9Jo35vESMmLBbl72Qx5F3JwZHZaBr3c0Jk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
    wrapGAppsHook3
  ];

  configureFlags = [
    "--enable-cloud-input-mode"
    "--enable-opencc"
  ];

  buildInputs = [
    ibus
    glib
    sqlite
    libpinyin
    (python3.withPackages (
      pypkgs: with pypkgs; [
        pygobject3
        (toPythonModule ibus)
      ]
    ))
    gtk3
    db
    lua
    opencc
    libsoup_3
    json-glib
    libnotify
  ];

  meta = {
    isIbusEngine = true;
    description = "IBus interface to the libpinyin input method";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      linsui
      ericsagnes
    ];
    platforms = lib.platforms.linux;
  };
}
