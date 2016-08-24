{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "stm32flash-1.0";

  src = fetchurl {
    url = https://stm32flash.googlecode.com/files/stm32flash.tar.gz;
    sha256 = "04k631g9lzvp9xr4sw51xpq1g542np61s1l8fpwx9rbsc8m5l0i6";
  };

  buildFlags = [ "CC=cc" ];

  installPhase = ''
    # Manually copy, make install copies to /usr/local/bin
    mkdir -pv $out/bin/
    cp stm32flash $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Open source flash program for the STM32 ARM processors using the ST bootloader";
    homepage = https://code.google.com/p/stm32flash/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.all; # Should work on all platforms
    maintainers = [ maintainers.the-kenny ];
  };
}
