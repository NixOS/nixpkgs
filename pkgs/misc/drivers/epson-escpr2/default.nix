{ stdenv, fetchurl, cups, busybox }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.1.1";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.  
    # NOTE: Don't forget to update the webarchive link too!
    urls = [ 
      "https://download3.ebz.epson.net/dsc/f/03/00/09/72/04/c6d928e83e558c4ba1e7e8bcb5c1fe080b8095eb/epson-inkjet-printer-escpr2-1.1.1-1lsb3.2.src.rpm"
      "https://web.archive.org/web/https://download3.ebz.epson.net/dsc/f/03/00/09/72/04/c6d928e83e558c4ba1e7e8bcb5c1fe080b8095eb/epson-inkjet-printer-escpr2-1.1.1-1lsb3.2.src.rpm"
    ];
    sha256 = "02vdlhvinsx6vsjq172b2c1vrfzkg0w9j5lbsnjvj6yq3yqz5b5q";
  };

  patches = [ ./cups-filter-ppd-dirs.patch ];

  buildInputs = [ cups busybox ];

  unpackPhase = ''
    rpm2cpio $src | cpio -idmv

    tar xvf ${pname}-${version}-1lsb3.2.tar.gz
    cd ${pname}-${version}
  '';

  meta = with stdenv.lib; {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
    description = "ESC/P-R 2 Driver (generic driver)";
    longDescription = ''
      Epson Inkjet Printer Driver 2 (ESC/P-R 2) for Linux and the
      corresponding PPD files.

      Refer to the description of epson-escpr for usage.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ ma9e ];
    platforms = platforms.linux;
  };
}
