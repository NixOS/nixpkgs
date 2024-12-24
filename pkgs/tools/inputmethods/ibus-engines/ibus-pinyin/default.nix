{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  intltool,
  pkg-config,
  python3,
  wrapGAppsHook3,
  glib,
  gtk3,
  ibus,
  lua,
  pyzy,
  sqlite,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "ibus-pinyin";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus-pinyin";
    rev = version;
    hash = "sha256-8nM/dEjkNhQNv6Ikv4xtRkS3mALDT6OYC1EAKn1zNtI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    ibus
    lua
    pyzy
    sqlite
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    isIbusEngine = true;
    description = "The PinYin engine for IBus";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ azuwis ];
    platforms = lib.platforms.linux;
  };
}
