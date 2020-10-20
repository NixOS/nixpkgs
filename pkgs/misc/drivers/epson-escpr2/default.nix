{ stdenv, fetchurl, cups, busybox }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.1.23";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.  
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/12/04/34/22448566e405c21c3f4436dfd8927176add3e680/epson-inkjet-printer-escpr2-1.1.23-1lsb3.2.src.rpm"
      "https://web.archive.org/web/20201019154323if_/https://download3.ebz.epson.net/dsc/f/03/00/12/04/34/22448566e405c21c3f4436dfd8927176add3e680/epson-inkjet-printer-escpr2-1.1.23-1lsb3.2.src.rpm"
    ];
    sha256 = "1d5zd8cwgp3n25ramdqwqb770iim7kh4l7hmhf6a6ivpy0cxpwx6";
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
