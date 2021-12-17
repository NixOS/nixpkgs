{ lib, stdenv, fetchurl, cups, busybox }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.1.42";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/13/07/72/df79cc238a167b9526f70cc123459c6bbe1edbad/epson-inkjet-printer-escpr2-1.1.42-1lsb3.2.src.rpm"
      "https://web.archive.org/web/20211029093638/https://download3.ebz.epson.net/dsc/f/03/00/13/07/72/df79cc238a167b9526f70cc123459c6bbe1edbad/epson-inkjet-printer-escpr2-1.1.42-1lsb3.2.src.rpm"
    ];
    sha256 = "sha256-CsZUurwwoXNWONZKAIkRd0ztmAr5wLWZhirCzJWWqMA=";
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
