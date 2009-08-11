{stdenv, fetchurl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "hal-info-20090716";
  
  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "179m2ip79jpr1mrmbcm2nx7l1mjlwcfmlw4ycd4dh0jrib64m3sp";
  };

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/hal;
    description = "Hardware data and quirks for HAL";
  };
}
