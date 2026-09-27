{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  ibus,
  libadwaita,
  libchewing,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ibus-chewing";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "chewing";
    repo = "ibus-chewing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3lNzQHuWFreIf4M6z4St5ZfOwjAJOMBLwzOI8KTCTEw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    ibus
    libadwaita
    libchewing
  ];

  enableParallelBuilding = true;

  meta = {
    isIbusEngine = true;
    description = "Chewing engine for IBus";
    homepage = "https://github.com/chewing/ibus-chewing";
    changelog = "https://github.com/chewing/ibus-chewing/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    platforms = lib.platforms.linux;
  };
})
