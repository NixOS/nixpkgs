{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:
stdenv.mkDerivation rec {
  name = "ccid-1.4.9";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/3866/${name}.tar.bz2";
    sha256 = "1dj0cw4js4ab678l94rf9p8a8gppkf1hm66qhmq5ajra6r5nv3m9";
  };

  patchPhase = ''
    sed -i 's,/usr/bin/env perl,${perl}/bin/perl,' src/*.pl
    substituteInPlace src/Makefile.in --replace /bin/echo echo
  '';
  preConfigure = ''
    configureFlags="$configureFlags --enable-usbdropdir=$out/pcsc/drivers"
  '';

  buildInputs = [ pcsclite pkgconfig libusb1 ];

  meta = {
    description = "ccid drivers for pcsclite";
    homepage = http://pcsclite.alioth.debian.org/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
