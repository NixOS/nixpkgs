{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "2019-08-16";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "96eefffcccc725425fd83be5e0704a5c32b79e54";
      sha256 = "05h57gcxhb2c84h99cyxxx4mzi6kd5fm8pjqkz3nq5vs3nv8cqhr";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "130cb86fa30cafbd575d38865fa546350d4c5f9c";
      sha256 = "0jmhgbpldzz8n8lncpzwfl5ym8zgss05y952rfpwcf9v5c7vgabx";
    })
  ];

  sourceRoot = ".";

  dontBuild = true;
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  installPhase = ''
    mkdir -p "$out/lib/firmware/brcm"

    # Wifi firmware
    for filename in firmware-nonfree/brcm/brcmfmac434??-sdio.*; do
      cp "$filename" "$out/lib/firmware/brcm"
    done

    # Bluetooth firmware
    cp bluez-firmware/broadcom/*.hcd "$out/lib/firmware/brcm"
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1r4alf1fbj6vkkf54d0anm47ymb6gn2ykl4a2hhd34b0hnf1dnhn";

  meta = with stdenv.lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3 and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
