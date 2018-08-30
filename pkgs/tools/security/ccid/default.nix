{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:

stdenv.mkDerivation rec {
  version = "1.4.29";
  name = "ccid-${version}";

  src = fetchurl {
    url = "https://ccid.apdu.fr/files/${name}.tar.bz2";
    sha256 = "0kdqmbma6sclsrbxy9w85h7cs0v11if4nc2r9v09613k8pl2lhx5";
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
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.linux;
  };
}
