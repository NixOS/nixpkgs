{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-scanner
, freetype
, libglvnd
, libxkbcommon
, wayland
, wayland-protocols
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sov";
  version = "0.92b";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = "sov";
    rev = finalAttrs.version;
    hash = "sha256-1L5D0pzcXbkz3VS7VB6ID8BJEbGeNxjo3xCr71CGcIo=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    freetype
    libglvnd
    libxkbcommon
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Workspace overview app for sway";
    homepage = "https://github.com/milgra/sov";
    license = lib.licenses.gpl3Only;
    mainProgram = "sov";
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.linux;
  };
})
