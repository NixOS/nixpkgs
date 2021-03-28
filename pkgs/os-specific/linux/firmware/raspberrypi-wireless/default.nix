{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "2020-12-01";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "1e4ee0c05bae10002124b56c0e44bb9ac6581ddc";
      sha256 = "10n6ibr3ra71f4hlvbpy8csjlgrapawxrr6jmijn470vkcqcpq27";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "b66ab26cebff689d0d3257f56912b9bb03c20567";
      sha256 = "0cffgsp0w7vv7ylpymdddx0bl9dx3pl7snlh30p4rr9srmn8869f";
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
  outputHash = "17k9y499kjc4zv7ivnsfrgfibwj0ldr3sqdgia4dackbr70jfg2h";

  meta = with lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3+ and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
