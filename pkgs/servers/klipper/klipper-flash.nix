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
, firmwareConfig ? ./simulator.cfg
}:
let
  supportedArches = [ "avr" "stm32" "lpc176x" ];
  matchBoard = with builtins; match ''^.*CONFIG_BOARD_DIRECTORY="([a-zA-Z0-9_]+)".*$'' (readFile firmwareConfig);
  boardArch = if matchBoard == null then null else builtins.head matchBoard;
in
writeShellApplication {
  name = "klipper-flash-${mcu}";
  runtimeInputs = [
    python2
    pkgsCross.avr.stdenv.cc
    gnumake
  ] ++ lib.optionals (boardArch == "avr") [ avrdude ] ++ lib.optionals (boardArch == "stm32") [ stm32flash ];
  text = ''
    if ${lib.boolToString (!builtins.elem boardArch supportedArches)}; then
      printf "Flashing Klipper firmware to your board is not supported yet.\n"
      printf "Please use the compiled firmware at ${klipper-firmware} and flash it using the tools provided for your microcontroller."
      exit 1
    fi
    if ${lib.boolToString (boardArch == "stm32")}; then
      make -C ${klipper.src} FLASH_DEVICE="${toString flashDevice}" OUT="${klipper-firmware}/" KCONFIG_CONFIG="${klipper-firmware}/config" serialflash
    else
      make -C ${klipper.src} FLASH_DEVICE="${toString flashDevice}" OUT="${klipper-firmware}/" KCONFIG_CONFIG="${klipper-firmware}/config" flash
    fi
  '';
}
