{ stdenv, lib, linuxPackages }:

with lib;

stdenv.mkDerivation rec {
  name = "rtlwifi_new-firmware-${linuxPackages.rtlwifi_new.version}";
  inherit (linuxPackages.rtlwifi_new) src;

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/lib/firmware"
    cp -rf firmware/rtlwifi/ "$out/lib/firmware"
  '';

  meta = {
    description = "Firmware for the newest Realtek rtlwifi codes";
    inherit (src.meta) homepage;
    license = licenses.unfreeRedistributableFirmware;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ tvorog ];
  };
}
