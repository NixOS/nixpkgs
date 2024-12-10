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
  version = "1.15.7";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    rev = version;
    hash = "sha256-Sr0zB6VeEYGDu1gx2kTVoaTm131F4K+/QH/+ibcbMT8=";
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

  meta = with lib; {
    isIbusEngine = true;
    description = "IBus interface to the libpinyin input method";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      linsui
      ericsagnes
    ];
    platforms = platforms.linux;
  };
}
