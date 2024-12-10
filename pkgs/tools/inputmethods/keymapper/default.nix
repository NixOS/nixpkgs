{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  dbus,
  libX11,
  libusb1,
  pkg-config,
  udev,
  wayland,
  libxkbcommon,
  gtk3,
  libappindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keymapper";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "keymapper";
    rev = finalAttrs.version;
    hash = "sha256-QfISsRm0j/VoTmpDQes5XQooXHcmjqRD/WS/nvPDl00=";
  };

  # all the following must be in nativeBuildInputs
  nativeBuildInputs = [
    cmake
    pkg-config
    dbus
    wayland
    libX11
    udev
    libusb1
    libxkbcommon
    gtk3
    libappindicator
  ];

  meta = {
    changelog = "https://github.com/houmain/keymapper/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "A cross-platform context-aware key remapper";
    homepage = "https://github.com/houmain/keymapper";
    license = lib.licenses.gpl3Only;
    mainProgram = "keymapper";
    maintainers = with lib.maintainers; [
      dit7ya
      spitulax
    ];
    platforms = lib.platforms.linux;
  };
})
