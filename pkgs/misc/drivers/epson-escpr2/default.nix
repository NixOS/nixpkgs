{ lib, stdenv, fetchurl, cups, busybox }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.1.49";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.
    url = "https://download3.ebz.epson.net/dsc/f/03/00/13/76/47/16f624dc1dfad10c3b4eb141c50c651a6360f69a/epson-inkjet-printer-escpr2-1.1.49-1lsb3.2.src.rpm";
    sha256 = "sha256-WKDOpS7YL7J/IaNQcTjcoyXNXJGOuEexopdhYFubf50=";
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
