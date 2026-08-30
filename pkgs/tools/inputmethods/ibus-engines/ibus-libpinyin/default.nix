{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
  lua,
  opencc,
  libsoup_3,
  json-glib,
  libnotify,
}:

stdenv.mkDerivation rec {
  pname = "ibus-libpinyin";
  version = "1.16.5";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    tag = version;
    hash = "sha256-3QZHovjzGifWLFVudCnJOwMn/M3Nzfn8CZ1HpQwzUVw=";
  };

  patches = [
    # Drop -std=c++0x, fix build with opencc >= 1.4.0 header files, which require C++17
    (fetchpatch2 {
      name = "fix-build-with-opencc-1.4.patch";
      url = "https://github.com/libpinyin/ibus-libpinyin/commit/42ad7d20b803c10ce6d8921ccff5c6282bb4818c.patch?full_index=1";
      hash = "sha256-ndAJd+EEyluvjZL1gXM8HbfgEtwQETw0Lu1WAwcou4M=";
    })
  ];

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
