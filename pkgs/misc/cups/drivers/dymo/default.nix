{
  stdenv,
  lib,
  fetchurl,
  cups,
  ...
}:

stdenv.mkDerivation rec {
  pname = "cups-dymo";
  version = "1.4.0.5";

  # exposed version and 'real' version may differ
  # in this case the download states '1.4.0' but the real version is '1.4.0.5'
  # this has the potential to break future builds
  dl-name = "dymo-cups-drivers-1.4.0";

  src = fetchurl {
    url = "http://download.dymo.com/dymo/Software/Download%20Drivers/Linux/Download/${dl-name}.tar.gz";
    sha256 = "0wagsrz3q7yrkzb5ws0m5faq68rqnqfap9p98sgk5jl6x7krf1y6";
  };

  buildInputs = [ cups ];
  patches = [ ./fix-includes.patch ];

  makeFlags = [
    "cupsfilterdir=$(out)/lib/cups/filter"
    "cupsmodeldir=$(out)/share/cups/model"
  ];

  meta = {
    description = "CUPS Linux drivers and SDK for DYMO printers";
    homepage = "https://www.dymo.com/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
