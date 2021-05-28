{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:

stdenv.mkDerivation rec {
  pname = "ccid";
  version = "1.4.33";

  src = fetchurl {
    url = "https://ccid.apdu.fr/files/${pname}-${version}.tar.bz2";
    sha256 = "0974h2v9wq0j0ajw3c7yckaw8wqcppb2npfhfhmv9phijy9xlmjj";
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
    homepage = "https://ccid.apdu.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
