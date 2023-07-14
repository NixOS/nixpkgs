{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gettext
, pkg-config
, wrapGAppsHook
, sqlite
, libpinyin
, db
, ibus
, glib
, gtk3
, python3
, lua
, opencc
, libsoup
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "ibus-libpinyin";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "ibus-libpinyin";
    rev = version;
    hash = "sha256-6M4tgIpMQul3R8xI29vyPIWX0n6YItZhdVA8vT9FIRw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
    wrapGAppsHook
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
    (python3.withPackages (pypkgs: with pypkgs; [
      pygobject3
      (toPythonModule ibus)
    ]))
    gtk3
    db
    lua
    opencc
    libsoup
    json-glib
  ];

  meta = with lib; {
    isIbusEngine = true;
    description = "IBus interface to the libpinyin input method";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ linsui ericsagnes ];
    platforms = platforms.linux;
  };
}
