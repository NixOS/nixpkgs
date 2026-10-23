{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  intltool,
  pkg-config,
  python3,
  wrapGAppsHook3,
  glib,
  gtk3,
  ibus,
  lua5_5,
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

  patches = [
    # lua 5.5 compat, https://www.lua.org/manual/5.5/manual.html#8.1
    (fetchpatch {
      url = "https://github.com/libpinyin/ibus-libpinyin/commit/9264c2fdb731516f803ca66e84c6ec17ab1cfbf7.patch";
      hash = "sha256-3UufD+4n4yrPOQx5YHPdNURmrup8WDyL7bwJTnq3wOI=";
    })
  ];

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
    lua5_5
    pyzy
    sqlite
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    isIbusEngine = true;
    description = "PinYin engine for IBus (deprecated, new users should switch to ibus-engines.libpinyin)";
    homepage = "https://github.com/ibus/ibus-pinyin";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ azuwis ];
    platforms = lib.platforms.linux;
  };
}
