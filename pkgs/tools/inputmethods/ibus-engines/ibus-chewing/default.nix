{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glib,
  gtk4,
  ibus,
  libadwaita,
  libchewing,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ibus-chewing";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "chewing";
    repo = "ibus-chewing";
    rev = "v${finalAttrs.version}";
    hash = "sha256-l2sXjXpiParDslVDG1mXmtGNj6qcLJMPxeaBYNQkqZA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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
    description = "The Chewing engine for IBus";
    homepage = "https://github.com/chewing/ibus-chewing";
    changelog = "https://github.com/chewing/ibus-chewing/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "ibus-chewing";
    platforms = lib.platforms.all;
  };
})
