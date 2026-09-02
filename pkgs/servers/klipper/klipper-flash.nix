{
  lib,
  writeShellApplication,
  klipper,
  klipper-firmware,
  avrdude,
  dfu-util,
  stm32flash,
  mcu ? "mcu",
  flashDevice ? null,
  canbusNetwork ? null,
  canbusDevice ? null,
  firmwareConfig ? ./simulator.cfg,
}:
let
  getConfigField =
    field:
    with builtins;
    let
      lines = lib.splitString "\n" (readFile firmwareConfig);
      matchLine = line: match ''${field}="?([a-zA-Z0-9_]+)"?.*'' (lib.trim line);
      matched = lib.findFirst (line: matchLine line != null) null lines;
    in
    if matched != null then head (matchLine matched) else null;
  matchPlatform = getConfigField "CONFIG_BOARD_DIRECTORY";
  matchBoard = getConfigField "CONFIG_MCU";
  matchAvrdudeProtocol = getConfigField "CONFIG_AVRDUDE_PROTOCOL";
  matchFlashApplicationAddress = getConfigField "CONFIG_FLASH_APPLICATION_ADDRESS";
  # Only stm32's require -s/--start (flash_stm32f4 in scripts/flash_usb.py)
  flashStartAddress = if matchPlatform == "stm32" then matchFlashApplicationAddress else null;
  flashUsbSupportedBoards = [
    "sam3"
    "sam4"
    "same70"
    "samd"
    "same5"
    "lpc176"
    "stm32f103"
    "stm32f4"
    "stm32f042"
    "stm32f070"
    "stm32f072"
    "stm32g0b1"
    "stm32f7"
    "stm32h7"
    "stm32l4"
    "stm32g4"
    "rp2"
  ];
in
assert lib.assertMsg (
  (flashDevice != null) != (canbusNetwork != null && canbusDevice != null)
  && ((canbusNetwork != null) == (canbusDevice != null))
) "Either set flashDevice or both canbusNetwork and canbusDevice";
writeShellApplication {
  name = "klipper-flash-${mcu}";
  runtimeInputs =
    [ ]
    ++ lib.optionals (flashDevice != null) (
      lib.optionals (matchPlatform == "avr") [ avrdude ]
      ++ lib.optionals (matchPlatform == "stm32") [
        stm32flash
        dfu-util
      ]
      ++ lib.optionals (matchPlatform == "lpc176x") [ dfu-util ]
      # bossac, hid-flash and RP2040 flash binaries are built by klipper-firmware
    );
  text =
    # generic USB script for most things with serial and bootloader (see MCU_TYPES in scripts/flash_usb.py)
    if flashDevice != null then
      if
        matchBoard != null
        && lib.any (prefix: lib.hasPrefix prefix matchBoard) flashUsbSupportedBoards
        && matchPlatform != null
      then
        ''
          ${klipper}/lib/scripts/flash_usb.py -t ${matchBoard} -d ${flashDevice}${
            lib.optionalString (flashStartAddress != null) " -s ${flashStartAddress}"
          } ${klipper-firmware}/klipper.bin "$@"
        ''
      else if matchPlatform == "avr" && matchAvrdudeProtocol != null && matchBoard != null then
        ''
          avrdude -p${matchBoard} -c${matchAvrdudeProtocol} -P"${flashDevice}" -D -U"flash:w:${klipper-firmware}/klipper.elf.hex:i"
        ''
      else
        ''
          cat <<EOF
          Board pair ${toString matchBoard}/${toString matchPlatform} (config ${firmwareConfig}) is not supported in NixOS auto flashing script.
          Please manually flash the firmware using the appropriate tool for your board.
          Built firmware is located here:
          ${klipper-firmware}
          EOF
        ''
    else
      ''
        ${klipper}/lib/scripts/flash_can.py -i ${canbusNetwork} -f ${klipper-firmware}/klipper.bin -u ${canbusDevice} "$@"
      '';
}
