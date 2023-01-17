{ lib, stdenvNoCC, linuxPackages }:

stdenvNoCC.mkDerivation {
  pname = "rtl8723bs-firmware";
  version = linuxPackages.rtl8723bs.version;
  inherit (linuxPackages.rtl8723bs) src;

  dontBuild = true;

  installPhase = ''
    mkdir -p                "$out/lib/firmware/rtlwifi"
    cp rtl8723bs_nic.bin    "$out/lib/firmware/rtlwifi"
    cp rtl8723bs_wowlan.bin "$out/lib/firmware/rtlwifi"
  '';

  meta = with lib; {
    description = "Firmware for RealTek 8723bs";
    homepage = "https://github.com/hadess/rtl8723bs";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ elitak ];
    platforms = with platforms; linux;
  };
}
