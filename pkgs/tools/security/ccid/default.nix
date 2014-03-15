{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:
stdenv.mkDerivation rec {
  version = "1.4.15";
  name = "ccid-${version}";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/c/ccid/ccid_${version}.orig.tar.bz2";
    sha256 = "02lrdmqlw2ilbmgcpi2h7w741p025c10frxdn5w3wnzi8qi1hdjl";
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
