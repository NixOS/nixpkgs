args@{
  klipper-firmware,
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
  klipper-flash,
  mcu ? "mcu",
  firmwareConfig ? ./simulator.cfg,
}:
# are used by flash scripts
# find those with `rg '\[\"lib'` inside of klipper repo
let
  flashBinaries = [
    "lib/bossac/bin/bossac"
    "lib/hidflash/hid-flash"
    "lib/rp2040_flash/rp2040_flash"
  ];
in
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
      echo " !!! Klipper KConfig has changed. Please run klipper-genconf to update your configuration."
    fi
  '';

  postPatch = ''
    patchShebangs .
  '';

  postBuild = ''
    # build flash binaries
    ${with builtins; concatStringsSep "\n" (map (path: "make ${path} $out/bin/ || true") flashBinaries)}
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

    mkdir -p $out/lib/

    ${
      with builtins;
      concatStringsSep "\n" (
        map (path: ''
          if [ -e ${path} ]; then
            mkdir -p $out/$(dirname ${path})
            cp -r ${path} $out/$(dirname ${path})
          fi
        '') flashBinaries
      )
    }
    rmdir $out/lib 2>/dev/null || echo "Flash binaries exist, not cleaning up lib/"

  '';

  dontFixup = true;

  passthru = {
    makeFlasher =
      { flashDevice }:
      klipper-flash.override {
        klipper-firmware = klipper-firmware.override args;
        inherit
          klipper
          firmwareConfig
          mcu
          flashDevice
          ;
      };
  };

  meta = with lib; {
    inherit (klipper.meta) homepage license;
    description = "Firmware part of Klipper";
    maintainers = with maintainers; [
      vtuan10
      cab404
    ];
    platforms = platforms.linux;
  };
}
