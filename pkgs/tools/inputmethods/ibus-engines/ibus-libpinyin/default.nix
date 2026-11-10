{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  gobject-introspection,
  pkg-config,
  wrapGAppsHook3,
  sqlite,
  libpinyin,
  db,
  ibus,
  glib,
  gtk3,
  python3,
  lua5_5,
  opencc,
  libsoup_3,
  json-glib,
  libnotify,
}:
let
  lua = lua5_5;
in

stdenv.mkDerivation rec {
  pname = "ibus-libpinyin";
  version = "1.16.6";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    tag = "v${version}";
    hash = "sha256-uPYqMtppo+lLq035Tny0zYQA4NkfJ7H5EL0U78iSRAM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    gobject-introspection.setupHook
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
    homepage = "https://github.com/libpinyin/ibus-libpinyin";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      linsui
    ];
    platforms = lib.platforms.linux;
  };
}
