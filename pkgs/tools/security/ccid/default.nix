{stdenv, fetchurl, pcsclite, pkgconfig, libusb, perl}:
stdenv.mkDerivation {
  name = "ccid-1.3.11";

  src = fetchurl {
    url = https://alioth.debian.org/frs/download.php/3080/ccid-1.3.11.tar.bz2;
    sha256 = "01l9956wids087d38bprr8jqcl05j48cdp25k9q7vzran215mgzp";
  };

  patchPhase = ''
    sed -i 's,/usr/bin/env perl,${perl}/bin/perl,' src/*.pl
  '';
  preConfigure = ''
    configureFlags="$configureFlags --enable-usbdropdir=$out/pcsc/drivers"
  '';

  buildInputs = [ pcsclite pkgconfig libusb ];

  meta = {
    description = "ccid drivers for pcsclite";
    homepage = http://pcsclite.alioth.debian.org/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
