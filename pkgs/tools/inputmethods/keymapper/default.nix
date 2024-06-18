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
, libxkbcommon
, gtk3
, libayatana-appindicator
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keymapper";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "keymapper";
    rev = finalAttrs.version;
    hash = "sha256-NB9sVSkd01lm9Ia8fGrnICjD1cNdPfcvJ++Yy3NO5QQ=";
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
    libayatana-appindicator
  ];

  meta = {
    changelog = "https://github.com/houmain/keymapper/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Cross-platform context-aware key remapper";
    homepage = "https://github.com/houmain/keymapper";
    license = lib.licenses.gpl3Only;
    mainProgram = "keymapper";
    maintainers = with lib.maintainers; [ dit7ya spitulax ];
    platforms = lib.platforms.linux;
  };
})
