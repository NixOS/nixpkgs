{ lib, stdenv, fetchurl, cups, busybox }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.1.25";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/12/46/43/e233a3fefeb49723ba4b0a2f357527e3b45bf53a/epson-inkjet-printer-escpr2-1.1.25-1lsb3.2.src.rpm"
      "https://web.archive.org/web/20210212220538if_/https://download3.ebz.epson.net/dsc/f/03/00/12/46/43/e233a3fefeb49723ba4b0a2f357527e3b45bf53a/epson-inkjet-printer-escpr2-1.1.25-1lsb3.2.src.rpm"
    ];
    sha256 = "sha256-8hgafO/1qOTVdfAdx7FpOOSLqfTl0sBFunuN/2q7KHw=";
  };

  patches = [ ./cups-filter-ppd-dirs.patch ];

  buildInputs = [ cups busybox ];

  unpackPhase = ''
    rpm2cpio $src | cpio -idmv

    tar xvf ${pname}-${version}-1lsb3.2.tar.gz
    cd ${pname}-${version}
  '';

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
