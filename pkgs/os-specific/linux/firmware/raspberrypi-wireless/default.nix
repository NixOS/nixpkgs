{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "2022-07-06";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "dd840d991939f5046959b8c564596c7228f9d41d";
      hash = "sha512-XvF6IHDoKBJkSs0Wyt8O1vcCMpSNS9WSYopn0+EyCr4btABGsHWTkgxb4nQbd+VbE6Ls2dcKr+c+X6aw/y1jhQ==";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "541e5a05d152e7e6f0d9be45622e4a3741e51c02";
      hash = "sha512-0erVWiFom0V5AMu+XlolJnY9Q5/RCFlZwUovMBMNdEPb+L5rHcCdrA7zehDX1oRNe8DPb4S5gjny0iG/G7G6NQ==";
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

    # CM4 symlink must be added since it's missing from upstream
    pushd $out/lib/firmware/brcm &>/dev/null
    ln -s "./brcmfmac43455-sdio.txt" "$out/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-compute-module.txt"
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
