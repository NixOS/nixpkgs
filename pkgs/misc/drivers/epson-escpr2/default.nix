{ stdenv, fetchurl, cups, busybox }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.1.11";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.  
    # NOTE: Don't forget to update the webarchive link too!
    urls = [ 
      "https://download3.ebz.epson.net/dsc/f/03/00/11/01/98/8ff121831d0a6be76e86b87c78178f3c93df6d0f/epson-inkjet-printer-escpr2-1.1.11-1lsb3.2.src.rpm"
      "https://web.archive.org/web/20200425154102/https://download3.ebz.epson.net/dsc/f/03/00/11/01/98/8ff121831d0a6be76e86b87c78178f3c93df6d0f/epson-inkjet-printer-escpr2-1.1.11-1lsb3.2.src.rpm"
    ];
    sha256 = "1gcdzmqli7jycljm66mdssivb3lk223ih6zg0l3lyn7hj2gbkinm";
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
    maintainers = with maintainers; [ ma9e ma27 ];
    platforms = platforms.linux;
  };
}
