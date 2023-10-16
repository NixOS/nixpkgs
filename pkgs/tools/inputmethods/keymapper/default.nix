{ lib
, stdenv
, fetchFromGitHub
, cmake
, dbus
, libX11
, libusb1
, pkg-config
, udev
, wayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keymapper";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "keymapper";
    rev = finalAttrs.version;
    hash = "sha256-QgrMkGja8kMhXUE/kvPMq66xv/9tE/mEphlaEyDPHnM=";
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
  ];

  meta = {
    changelog = "https://github.com/houmain/keymapper/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "A cross-platform context-aware key remapper";
    homepage = "https://github.com/houmain/keymapper";
    license = lib.licenses.gpl3Only;
    mainProgram = "keymapper";
    maintainers = with lib.maintainers; [ dit7ya ];
    platforms = lib.platforms.linux;
  };
})
