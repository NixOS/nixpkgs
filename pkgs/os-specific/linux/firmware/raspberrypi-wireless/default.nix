{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "unstable-2023-11-15";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "d9d4741caba7314d6500f588b1eaa5ab387a4ff5";
      hash = "sha256-CjbZ3t3TW/iJ3+t9QKEtM9NdQU7SwcUCDYuTmFEwvhU=";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "88aa085bfa1a4650e1ccd88896f8343c22a24055";
      hash = "sha256-Yynww79LPPkau4YDSLI6IMOjH64nMpHUdGjnCfIR2+M=";
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
