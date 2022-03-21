{ lib
, writeShellApplication
, gnumake
, pkgsCross
, klipper
, klipper-firmware
, python2
, avrdude
, stm32flash
, mcu ? "mcu"
, flashDevice ? "/dev/null"
}:
let
  firmwareConfig = builtins.readFile "${klipper-firmware}/config";
  isNotSupported = with builtins; isNull (match ''^.*CONFIG_BOARD_DIRECTORY="(avr|stm32|lpc176x)".*$'' firmwareConfig);
  isNotStm = with builtins; isNull (match ''^.*CONFIG_BOARD_DIRECTORY="(stm32)".*$'' firmwareConfig);
in
writeShellApplication {
  name = "klipper-flash-${mcu}";
  runtimeInputs = [
    python2
    avrdude
    stm32flash
    pkgsCross.avr.stdenv.cc
  ];
  text = ''
    NOT_SUPPORTED=${lib.boolToString isNotSupported}
    NOT_STM=${lib.boolToString isNotStm}
    if $NOT_SUPPORTED; then
      printf "Flashing Klipper firmware to your board is not supported yet.\n"
      printf "Please use the compiled firmware at ${klipper-firmware} and flash it using the tools provided for your microcontroller."
      exit 1
    fi
    pushd ${klipper.src}
    if $NOT_STM; then
      ${gnumake}/bin/make FLASH_DEVICE="${toString flashDevice}" OUT="${klipper-firmware}/" KCONFIG_CONFIG="${klipper-firmware}/config" flash
    else
      ${gnumake}/bin/make FLASH_DEVICE="${toString flashDevice}" OUT="${klipper-firmware}/" KCONFIG_CONFIG="${klipper-firmware}/config" serialflash
    fi
    popd
  '';
}
