{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "2021-11-02";

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
      rev = "54ffdd6e2ea6055d46656b78e148fe7def3ec9d8";
      sha256 = "4WTrs/tUyOugufRrrh0qsEmhPclQD64ypYysxsnOyS8=";
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
  outputHash = "l+7VOq7CV5QA8/FWjMBGDcxq8Qe7NFf6E2Y42htZEgE=";

  meta = with lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3+ and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
