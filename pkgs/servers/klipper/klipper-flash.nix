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
      matches = match ''^.*${field}="([a-zA-Z0-9_]+)".*$'' (readFile firmwareConfig);
    in
    if matches != null then head matches else null;
  matchPlatform = getConfigField "CONFIG_BOARD_DIRECTORY";
  matchBoard = getConfigField "CONFIG_MCU";
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
      if matchBoard != null && matchPlatform != null then
        ''
          ${klipper}/lib/scripts/flash_usb.py -t ${matchBoard} -d ${flashDevice} ${klipper-firmware}/klipper.bin "$@"
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
