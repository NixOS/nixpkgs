{ lib
, stdenv
, fetchurl
, pcsclite
, pkg-config
, libusb1
, perl
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "ccid";
  version = "1.5.2";

  src = fetchurl {
    url = "https://ccid.apdu.fr/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-E5NEh+b4tI9pmhbTZ8x6GvejyodN5yGsbpYzvrhuchk=";
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

  # The resulting shared object ends up outside of the default paths which are
  # usually getting stripped.
  stripDebugList = ["pcsc"];

  passthru.updateScript = gitUpdater {
    url = "https://salsa.debian.org/rousseau/CCID.git";
  };

  meta = with lib; {
    description = "PC/SC driver for USB CCID smart card readers";
    homepage = "https://ccid.apdu.fr/";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.anthonyroussel ];
    platforms = platforms.unix;
  };
}
