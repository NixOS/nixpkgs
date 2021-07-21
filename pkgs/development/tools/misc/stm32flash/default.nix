{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "stm32flash";
  version = "0.5";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "01p396daqw3zh6nijffbfbwyqza33bi2k4q3m5yjzs02xwi99alp";
  };

  buildFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    # Manually copy, make install copies to /usr/local/bin
    mkdir -pv $out/bin/
    cp stm32flash $out/bin/
  '';

  meta = with lib; {
    description = "Open source flash program for the STM32 ARM processors using the ST bootloader";
    homepage = "https://sourceforge.net/projects/stm32flash/";
    license = lib.licenses.gpl2;
    platforms = platforms.all; # Should work on all platforms
    maintainers = with maintainers; [ elitak ];
  };
}
