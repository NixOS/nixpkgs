{stdenv, fetchurl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "hal-info-20091130";
  
  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "092jhzpxa2h8djf8pijql92m70q87yds22686ryrfna3xbm90niv";
  };

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/hal;
    description = "Hardware data and quirks for HAL";
  };
}
