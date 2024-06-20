{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "unstable-2024-02-26";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "78d6a07730e2d20c035899521ab67726dc028e1c";
      hash = "sha256-KakKnOBeWxh0exu44beZ7cbr5ni4RA9vkWYb9sGMb8Q=";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "223ccf3a3ddb11b3ea829749fbbba4d65b380897";
      hash = "sha256-BGq0+cr+xBRwQM/LqiQuRWuZpQsKM5jfcrNCqWMuVzM=";
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
    cp -rv "$NIX_BUILD_TOP/bluez-firmware/debian/firmware/broadcom/." "$out/lib/firmware/brcm"

    # brcmfmac43455-sdio.bin is a symlink to the non-existent path: ../cypress/cyfmac43455-sdio.bin.
    # See https://github.com/RPi-Distro/firmware-nonfree/issues/26
    ln -s "./cyfmac43455-sdio-standard.bin" "$out/lib/firmware/cypress/cyfmac43455-sdio.bin"

    pushd $out/lib/firmware/brcm &>/dev/null
    # Symlinks for Zero 2W
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
