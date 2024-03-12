{ lib, stdenv, fetchurl, cups, rpm, cpio }:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.2.9";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7210" to get to the most recent
    # version.
    url = "https://download3.ebz.epson.net/dsc/f/03/00/15/33/94/3bf10a30a1f8b5b91ddbafa4571c073878ec476b/epson-inkjet-printer-escpr2-1.2.9-1.src.rpm";
    sha256 = "sha256-2smNBTMSqoKYsGUoBtIHS3Fwk9ODbiXaP7Dtq69FG9U=";
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
