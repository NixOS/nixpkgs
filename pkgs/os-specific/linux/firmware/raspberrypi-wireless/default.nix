{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "unstable-2023-05-04";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "9556b08ace2a1735127894642cc8ea6529c04c90";
      hash = "sha256-gKGK0XzNrws5REkKg/JP6SZx3KsJduu53SfH3Dichkc=";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "2b465a10b04555b7f45b3acb85959c594922a3ce";
      hash = "sha256-9UgB8f2AaxG7S5Px46jOP9wUeO1VXKB0uJiPWh32oDI=";
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
    cp -rv "$NIX_BUILD_TOP/firmware-nonfree/debian/config/brcm80211/." "$out/lib/firmware/"

    # Bluetooth firmware
    cp -rv "$NIX_BUILD_TOP/bluez-firmware/broadcom/." "$out/lib/firmware/brcm"

    # brcmfmac43455-stdio.bin is a symlink to the non-existent path: ../cypress/cyfmac43455-stdio.bin.
    # See https://github.com/RPi-Distro/firmware-nonfree/issues/26
    ln -s "./cyfmac43455-sdio-standard.bin" "$out/lib/firmware/cypress/cyfmac43455-sdio.bin"

    pushd $out/lib/firmware/brcm &>/dev/null
    # Symlinks for Zero 2W
    ln -s "./brcmfmac43436-sdio.bin" "$out/lib/firmware/brcm/brcmfmac43430b0-sdio.raspberrypi,model-zero-2-w.bin"
    ln -s "./brcmfmac43436-sdio.txt" "$out/lib/firmware/brcm/brcmfmac43430b0-sdio.raspberrypi,model-zero-2-w.txt"
    ln -s "./brcmfmac43436-sdio.clm_blob" "$out/lib/firmware/brcm/brcmfmac43430b0-sdio.clm_blob"
    popd &>/dev/null

    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3+ and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
