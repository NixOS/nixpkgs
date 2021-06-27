{ lib, stdenv, fetchurl, cups }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.1.34";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/12/85/48/fd5de1ecd7270b0398399355e265c99dfd1dbafb/epson-inkjet-printer-escpr2-1.1.34.tar.gz"
      "https://web.archive.org/web/20210627160654/https://download3.ebz.epson.net/dsc/f/03/00/12/85/48/fd5de1ecd7270b0398399355e265c99dfd1dbafb/epson-inkjet-printer-escpr2-1.1.34.tar.gz"
    ];
    sha256 = "sha256-sHBGWbkZ+zolHehyXQR8U2AyKSrgDSPmrkrcfcx/bAs=";
  };

  patches = [ ./cups-filter-ppd-dirs.patch ];

  buildInputs = [ cups ];

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
