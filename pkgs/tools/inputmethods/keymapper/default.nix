{ lib
, stdenv
, fetchFromGitHub
, cmake
, asio
, dbus
, libX11
, libusb1
, pkg-config
, udev
, wayland
, darwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keymapper";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "keymapper";
    rev = finalAttrs.version;
    hash = "sha256-CfZdLeWgeNwy9tEJ3UDRplV0sRcKE4J6d3CxC9gqdmE=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Avoid fetching asio dependency during buildtime, instead use asio from nixpkgs.
    ./dont-fetch-asio.patch
  ];

  # all of the following must be in nativeBuildInputs
  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals stdenv.isLinux [
    dbus
    libusb1
    libX11
    udev
    wayland
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Carbon
    asio
  ];

  meta = {
    changelog = "https://github.com/houmain/keymapper/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "A cross-platform context-aware key remapper";
    homepage = "https://github.com/houmain/keymapper";
    license = lib.licenses.gpl3Only;
    mainProgram = "keymapper";
    maintainers = with lib.maintainers; [ dit7ya ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
