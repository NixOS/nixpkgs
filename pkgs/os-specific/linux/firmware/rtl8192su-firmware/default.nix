{ lib, stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
  pname = "rtl8192su";
  version = "unstable-2016-10-05";

  src = fetchFromGitHub {
    owner = "chunkeey";
    repo = "rtl8192su";
    rev = "c00112c9a14133290fe30bd3b44e45196994cb1c";
    sha256 = "0j3c35paapq1icmxq0mg7pm2xa2m69q7bkfmwgq99d682yr2cb5l";
  };

  dontBuild = true;

  installPhase = ''
    for i in rtl8192sfw.bin \
             rtl8192sufw-ap.bin \
             rtl8192sufw-apple.bin \
             rtl8192sufw-windows.bin \
             rtl8712u-linux-firmware-bad.bin \
             rtl8712u-most-recent-v2.6.6-bad.bin \
             rtl8712u-most-recent-v2.6.6-bad.bin \
             rtl8712u-oldest-but-good.bin;
    do
      install -D -pm644 firmwares/$i $out/lib/firmware/rtlwifi/$i
    done
  '';

  meta = with lib; {
    description = "Firmware for Realtek RTL8188SU/RTL8191SU/RTL8192SU";
    homepage = "https://github.com/chunkeey/rtl8192su";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ mic92 ];
    platforms = with platforms; linux;
  };
}
