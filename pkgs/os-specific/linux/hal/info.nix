{stdenv, fetchurl, pkgconfig, hal}:

stdenv.mkDerivation rec {
  name = "hal-info-20090414";
  
  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "03zsh4psq189k7i8mwazsmallwc10naavkdrp1sp68jjjkf8gp9k";
  };

  buildInputs = [pkgconfig hal];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/hal;
    description = "Hardware data and quirks for HAL";
  };
}
