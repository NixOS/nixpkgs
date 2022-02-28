{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "2022-01-20";

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
      rev = "99d5c588e95ec9c9b86d7e88d3cf85b4f729d2bc";
      sha256 = "0pfgadblxs8cji8d227v6wsml8x6vzsz7j12jfidvvp01dhry3n6";
    })
  ];

  sourceRoot = ".";

  dontBuild = true;
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/firmware/brcm"

    # Wifi firmware
    for filename in firmware-nonfree/brcm/brcmfmac434??-sdio.*; do
      cp "$filename" "$out/lib/firmware/brcm"
    done

    # Bluetooth firmware
    cp bluez-firmware/broadcom/*.hcd "$out/lib/firmware/brcm"
    runHook postInstall
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0gipxq1j0rp9x8psl5zfh14yg09q39dd6ixkysh3bczkb05h83qp";

  meta = with lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3+ and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
