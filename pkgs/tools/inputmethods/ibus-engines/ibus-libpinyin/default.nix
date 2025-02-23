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
}:

stdenv.mkDerivation rec {
  pname = "ibus-libpinyin";
  version = "1.15.8";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    tag = version;
    hash = "sha256-u21avBSSu/78tLoyFI9XGocC7rT/64L5HqQQj3Zg1Mc=";
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
