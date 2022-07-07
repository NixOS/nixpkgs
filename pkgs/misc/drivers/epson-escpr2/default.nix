{ lib, stdenv, fetchurl, cups, busybox }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.1.48";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.
    url = "https://download3.ebz.epson.net/dsc/f/03/00/13/52/26/977f2b2c13cc185981479fbd225b802c35c92beb/epson-inkjet-printer-escpr2-1.1.48-1lsb3.2.src.rpm";
    sha256 = "sha256-E+ZZLt7hdXojQkKr0qgdL+UuSZXAESWW9AHIfAX1jK0=";
  };

  unpackPhase = ''
    runHook preUnpack

    rpm2cpio $src | cpio -idmv
    tar xvf ${pname}-${version}-1lsb3.2.tar.gz
    cd ${pname}-${version}

    runHook postUnpack
  '';

  patches = [ ./cups-filter-ppd-dirs.patch ];

  buildInputs = [ cups ];
  nativeBuildInputs = [ busybox ];

  meta = with lib; {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
    description = "ESC/P-R 2 Driver (generic driver)";
    longDescription = ''
      Epson Inkjet Printer Driver 2 (ESC/P-R 2) for Linux and the
      corresponding PPD files.

      Refer to the description of epson-escpr for usage.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ ma9e ma27 ];
    platforms = platforms.linux;
  };
}
