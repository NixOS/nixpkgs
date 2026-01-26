{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  python3,
  ibus,
  pkg-config,
  gtk3,
  m17n_lib,
  wrapGAppsHook3,
  gobject-introspection,
}:

let

  python = python3.withPackages (
    ps: with ps; [
      pygobject3
      dbus-python
    ]
  );

in

stdenv.mkDerivation rec {
  pname = "ibus-typing-booster";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "mike-fabian";
    repo = "ibus-typing-booster";
    rev = version;
    hash = "sha256-DFhWAHjvjaLch+OU5XZYEqpRZMa4LmYzn3oFgweKsEU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = [
    python
    ibus
    gtk3
    m17n_lib
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${m17n_lib}/lib")
  '';

  meta = {
    homepage = "https://mike-fabian.github.io/ibus-typing-booster/";
    license = lib.licenses.gpl3Plus;
    description = "Completion input method for faster typing";
    mainProgram = "emoji-picker";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    isIbusEngine = true;
  };
}
