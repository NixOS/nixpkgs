{
  stdenv,
  lib,
  pkg-config,
  pkgsCross,
  bintools-unwrapped,
  libffi,
  libusb1,
  wxGTK32,
  python3,
  gcc-arm-embedded,
  klipper,
  avrdude,
  stm32flash,
  mcu ? "mcu",
  firmwareConfig ? ./simulator.cfg,
}:
stdenv.mkDerivation rec {
  name = "klipper-firmware-${mcu}-${version}";
  version = klipper.version;
  src = klipper.src;

  nativeBuildInputs = [
    python3
    pkgsCross.avr.stdenv.cc
    gcc-arm-embedded
    bintools-unwrapped
    libffi
    libusb1
    avrdude
    stm32flash
    pkg-config
    wxGTK32 # Required for bossac
  ];

  configurePhase = ''
    cp ${firmwareConfig} ./.config
    chmod +w ./.config
    echo qy | { make menuconfig >/dev/null || true; }
    if ! diff ${firmwareConfig} ./.config; then
      echo " !!! Menuconfig has changed. Please update your configuration."
    fi
  '';

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [
    "V=1"
    "WXVERSION=3.2"
  ];

  installPhase = ''
    mkdir -p $out
    cp ./.config $out/config
    cp out/klipper.bin $out/ || true
    cp out/klipper.elf $out/ || true
    cp out/klipper.uf2 $out/ || true
  '';

  dontFixup = true;

  meta = with lib; {
    inherit (klipper.meta) homepage license;
    description = "Firmware part of Klipper";
    maintainers = with maintainers; [ vtuan10 cab404 ];
    platforms = platforms.linux;
  };
}
