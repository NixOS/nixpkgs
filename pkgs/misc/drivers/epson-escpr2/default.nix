{ lib, stdenv, fetchurl, cups, rpm, cpio }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.2.10";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.
    url = "https://download3.ebz.epson.net/dsc/f/03/00/15/87/52/84d8972472981a5337b96610c39c8c7586256b55/epson-inkjet-printer-escpr2-1.2.10-1.src.rpm";
    sha256 = "sha256-vrAVarGBp8eI07WMtQSmuNpX5iS26+B2iP/b7U8mJmo=";
  };

  unpackPhase = ''
    runHook preUnpack

    rpm2cpio $src | cpio -idmv
    tar xvf ${pname}-${version}-1.tar.gz
    cd ${pname}-${version}

    runHook postUnpack
  '';

  patches = [ ./cups-filter-ppd-dirs.patch ];

  buildInputs = [ cups ];
  nativeBuildInputs = [ rpm cpio ];

  meta = with lib; {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
    description = "ESC/P-R 2 Driver (generic driver)";
    longDescription = ''
      Epson Inkjet Printer Driver 2 (ESC/P-R 2) for Linux and the
      corresponding PPD files.

      Refer to the description of epson-escpr for usage.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ ma9e ma27 shawn8901 ];
    platforms = platforms.linux;
  };
}
