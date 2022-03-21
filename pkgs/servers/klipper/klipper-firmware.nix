{ stdenv
, lib
, pkg-config
, pkgsCross
, bintools-unwrapped
, libffi
, libusb1
, wxGTK
, python2
, python3
, gcc-arm-embedded
, klipper
, avrdude
, stm32flash
, mcu ? "mcu"
, firmwareConfig ? ./simulator.cfg
, flashDevice ? null
}: stdenv.mkDerivation rec {
  name = "klipper-firmware-${mcu}-${version}";
  version = klipper.version;
  src = klipper.src;

  nativeBuildInputs = [
    python2
    python3
    pkgsCross.avr.stdenv.cc
    gcc-arm-embedded
    bintools-unwrapped
    libffi
    libusb1
    avrdude
    stm32flash
    pkg-config
    wxGTK # Required for bossac
  ];

  preBuild = "cp ${firmwareConfig} ./.config";

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [
    "V=1"
    "KCONFIG_CONFIG=${firmwareConfig}"
  ];

  installPhase = ''
    mkdir -p $out
    cp ./.config $out/config
    cp -r out/* $out

    if ${lib.boolToString (!isNull flashDevice)}; then
      make FLASH_DEVICE=${toString flashDevice} OUT=$out/ KCONFIG_CONFIG=$out/config flash
    fi
  '';

  dontFixup = true;

  meta = {
    inherit (klipper.meta) homepage license;
    description = "Firmware part of Klipper";
    maintainers = with lib.maintainers; [ vtuan10 ];
    platforms = lib.platforms.linux;
  };
}
