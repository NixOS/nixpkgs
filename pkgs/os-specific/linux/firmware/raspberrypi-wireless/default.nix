{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "2021-12-06";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "e7fd166981ab4bb9a36c2d1500205a078a35714d";
      hash = "sha256-6xBdXwAGA1N42k1KKYrEgtsxtFAtrwhKdIrYY39Fb7Y=";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "99d5c588e95ec9c9b86d7e88d3cf85b4f729d2bc";
      hash = "sha256-xg6fYQvg7t2ikyLI8/XfpiNaNTf7CNFQlAzpTldTz10=";
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
    shopt -s extglob
    for filename in firmware-nonfree/brcm/brcmfmac434??{,s}-sdio.*; do
      cp "$filename" "$out/lib/firmware/brcm"
    done

    # Bluetooth firmware
    cp bluez-firmware/broadcom/*.hcd "$out/lib/firmware/brcm"
    runHook postInstall
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-Fw8EC1jzszWg9rNH01oaOIHnSYDuF6ov6ulmIAPuNz4=";

  meta = with lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3+ and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
