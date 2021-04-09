{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "2021-01-28";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "e7fd166981ab4bb9a36c2d1500205a078a35714d";
      sha256 = "1dkg8mzn7n4afi50ibrda2s33nw2qj52jjjdv9w560q601gms47b";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "83938f78ca2d5a0ffe0c223bb96d72ccc7b71ca5";
      sha256 = "1l4zz86y2hjyvdwjy75abyjwh3wqknd71y3vh1iw5nd0hws8ranp";
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
  outputHash = "0a54gyrq6jfxxvimaa4yjfiyfwf7wv58v0a32l74yrzyarr3ldby";

  meta = with lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3+ and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
