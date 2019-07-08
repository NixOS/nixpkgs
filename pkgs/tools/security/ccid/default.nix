{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:

stdenv.mkDerivation rec {
  version = "1.4.30";
  name = "ccid-${version}";

  src = fetchurl {
    url = "https://ccid.apdu.fr/files/${name}.tar.bz2";
    sha256 = "0z7zafdg75fr1adlv2x0zz34s07gljcjg2lsz76s1048w1xhh5xc";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace src/Makefile.in --replace /bin/echo echo
  '';

  preConfigure = ''
    configureFlagsArray+=("--enable-usbdropdir=$out/pcsc/drivers")
  '';

  nativeBuildInputs = [ pkgconfig perl ];
  buildInputs = [ pcsclite libusb1 ];

  meta = with stdenv.lib; {
    description = "ccid drivers for pcsclite";
    homepage = https://ccid.apdu.fr/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
