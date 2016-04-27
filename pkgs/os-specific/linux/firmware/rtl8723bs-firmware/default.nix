{ stdenv, linuxPackages }:
with stdenv.lib;
stdenv.mkDerivation {
  name = "rtl8723bs-firmware-${linuxPackages.rtl8723bs.rev}";
  inherit (linuxPackages.rtl8723bs) src;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p                "$out/lib/firmware/rtlwifi"
    cp rtl8723bs_nic.bin    "$out/lib/firmware/rtlwifi"
    cp rtl8723bs_wowlan.bin "$out/lib/firmware/rtlwifi"
  '';

  meta = with stdenv.lib; {
    description = "Firmware for RealTek 8723bs";
    homepage = https://github.com/hadess/rtl8723bs;
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ elitak ];
  };
}
