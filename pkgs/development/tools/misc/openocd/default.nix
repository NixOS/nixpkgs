{stdenv, fetchurl, libftdi}:

stdenv.mkDerivation {
  name = "openocd-0.3.1";

  src = fetchurl {
    url = "http://download.berlios.de/openocd/openocd-0.3.1.tar.bz2";
    sha256 = "1ww66gj4mn3ih4k0b2w21795gfl6g53nm41irii9n7bbjn2dmgrp";
  };


  configureFlags = [ "--enable-ft2232_libftdi" "--disable-werror" ];

  buildInputs = [ libftdi ];

  meta = {
    homepage = http://openocd.berlios.de;
    description = "Open On Chip Debugger";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
