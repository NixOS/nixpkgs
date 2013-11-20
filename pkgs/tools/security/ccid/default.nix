{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:
stdenv.mkDerivation rec {
  name = "ccid-1.4.13";

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/pcsc-lite-ccid/ccid-1.4.13.tar.bz2/89c167a873df1f8bc0dc907ce209e5ff/ccid-1.4.13.tar.bz2";
    sha256 = "1w0mxb5qzps9x2fcggv958mwgwmvfxxj4nspxs67fa7qg7r6yxar";
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
