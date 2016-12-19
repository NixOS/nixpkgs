{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:

stdenv.mkDerivation rec {
  version = "1.4.23";
  name = "ccid-${version}";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/4169/ccid-1.4.23.tar.bz2";
    sha256 = "0s7c2g8idnnh19958aswaa2s51ncr2j7gqrkk5g95qpfnv7asdh8";
  };

  patchPhase = ''
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
    homepage = http://pcsclite.alioth.debian.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric wkennington ];
    platforms = platforms.linux;
  };
}
