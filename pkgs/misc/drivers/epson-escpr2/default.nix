{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  cups,
  rpm,
  cpio,
}:

stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.2.13";

  src = fetchurl {
    # To find the most recent version go to
    # https://support.epson.net/linux/Printer/LSB_distribution_pages/en/escpr2.php
    # and retreive the download link for source package for x86 CPU
    url = "https://download3.ebz.epson.net/dsc/f/03/00/16/00/23/60c57d2774eea9b27d2c636f0c3615b8619291b3/epson-inkjet-printer-escpr2-1.2.13-1.src.rpm";
    sha256 = "sha256-yOZqeNrtC28OucY5HOT6OY6qqvLSGh1LTIXbIB7VNrY=";
  };

  unpackPhase = ''
    runHook preUnpack

    rpm2cpio $src | cpio -idmv
    tar xvf ${pname}-${version}-1.tar.gz
    cd ${pname}-${version}

    runHook postUnpack
  '';

  buildInputs = [ cups ];
  nativeBuildInputs = [
    autoreconfHook
    rpm
    cpio
  ];

  configureFlags = [
    "--with-cupsfilterdir=${builtins.placeholder "out"}/lib/cups/filter"
    "--with-cupsppddir=${builtins.placeholder "out"}/share/cups/model"
  ];

  meta = with lib; {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
    description = "ESC/P-R 2 Driver (generic driver)";
    longDescription = ''
      Epson Inkjet Printer Driver 2 (ESC/P-R 2) for Linux and the
      corresponding PPD files.

      Refer to the description of epson-escpr for usage.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      ma9e
      ma27
      shawn8901
    ];
    platforms = platforms.linux;
  };
}
