{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "stm32flash-0.5";

  src = fetchurl {
    url = "mirror://sourceforge/stm32flash/${name}.tar.gz";
    sha256 = "01p396daqw3zh6nijffbfbwyqza33bi2k4q3m5yjzs02xwi99alp";
  };

  buildFlags = [ "CC=cc" ];

  installPhase = ''
    # Manually copy, make install copies to /usr/local/bin
    mkdir -pv $out/bin/
    cp stm32flash $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Open source flash program for the STM32 ARM processors using the ST bootloader";
    homepage = https://sourceforge.net/projects/stm32flash/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.all; # Should work on all platforms
    maintainers = with maintainers; [ the-kenny elitak ];
  };
}
