{ lib, stdenv, fetchurl, pcsclite, pkg-config, libusb1, perl }:

stdenv.mkDerivation rec {
  pname = "ccid";
  version = "1.4.34";

  src = fetchurl {
    url = "https://ccid.apdu.fr/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-5vdkW1mpooROtLGn7/USlg1/BKRlSvAvf9L4re1dtAo=";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace src/Makefile.in --replace /bin/echo echo
  '';

  preConfigure = ''
    configureFlagsArray+=("--enable-usbdropdir=$out/pcsc/drivers")
  '';

  nativeBuildInputs = [ pkg-config perl ];
  buildInputs = [ pcsclite libusb1 ];

  meta = with lib; {
    description = "ccid drivers for pcsclite";
    homepage = "https://ccid.apdu.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
