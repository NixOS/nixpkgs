{ stdenv, fetchurl, fetchFromGitHub, dpkg }:

stdenv.mkDerivation rec {
  name = "raspberrypi-wireless-firmware-${version}";
  version = "2018-08-20";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "ade2bae1aaaebede09abb8fb546f767a0e4c7804";
      sha256 = "07gm76gxp5anv6paryvxcp34a86fkny8kdlzqhzcpfczzglkp6ag";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "b518de45ced519e8f7a499f4778100173402ae43";
      sha256 = "1d5026ic9awji6c67irpwsxpxgsc0dhn11d3abkxi2vvra1pir4g";
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
  outputHash = "1s5gb00v42s5izbaw8irs1fwvhh7z9wl07czc0nkw6p91871ivb7";

  meta = with stdenv.lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3 and Zero W";
    homepage = https://github.com/RPi-Distro/firmware-nonfree;
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
