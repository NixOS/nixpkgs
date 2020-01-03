{ stdenv, fetchurl, pcsclite, pkgconfig, libusb1, perl }:

stdenv.mkDerivation rec {
  pname = "ccid";
  version = "1.4.31";

  src = fetchurl {
    url = "https://ccid.apdu.fr/files/${pname}-${version}.tar.bz2";
    sha256 = "1xz8ikr6vk73w3xnwb931yq8lqc1zrj8c3v34n6h63irwjvdfj3b";
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
