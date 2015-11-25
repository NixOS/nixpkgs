{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:

stdenv.mkDerivation rec {
  version = "1.4.20";
  name = "ccid-${version}";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/4140/ccid-1.4.20.tar.bz2";
    sha256 = "1g0w4pv6q30d8lhs3kd6nywkhh34nhf9fbcbcvbxdvk3pdjvh320";
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
