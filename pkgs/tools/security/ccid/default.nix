{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:

stdenv.mkDerivation rec {
  version = "1.4.18";
  name = "ccid-${version}";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/c/ccid/ccid_${version}.orig.tar.bz2";
    sha256 = "1aj14lkmfaxkhk5swqfgn2x18j7fijxs0jnxnx9cdc9f5mxaknsz";
  };

  patchPhase = ''
    sed -i 's,/usr/bin/env perl,${perl}/bin/perl,' src/*.pl
    substituteInPlace src/Makefile.in --replace /bin/echo echo
  '';
  preConfigure = ''
    configureFlags="$configureFlags --enable-usbdropdir=$out/pcsc/drivers"
  '';

  buildInputs = [ pcsclite pkgconfig libusb1 ];

  meta = with stdenv.lib; {
    description = "ccid drivers for pcsclite";
    homepage = http://pcsclite.alioth.debian.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric wkennington ];
    platforms = with platforms; linux;
  };
}
