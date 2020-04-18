{ stdenv, fetchurl, cups }:

stdenv.mkDerivation {
  pname = "epson-escpr";
  version = "1.7.3";

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7110" to get to the most recent
    # version.  
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/09/83/26/f90d0f70b33a9d7d77a2408364c47fba1ccbf943/epson-inkjet-printer-escpr-1.7.3-1lsb3.2.tar.gz"
      "https://web.archive.org/web/https://download3.ebz.epson.net/dsc/f/03/00/09/83/26/f90d0f70b33a9d7d77a2408364c47fba1ccbf943/epson-inkjet-printer-escpr-1.7.3-1lsb3.2.tar.gz"
    ];
    sha256 = "0r3jkdfk33irha9gpyvhha056ans59p7dq9i153i292ifjsd8458";
  };

  patches = [ ./cups-filter-ppd-dirs.patch ];

  buildInputs = [ cups ];

  meta = with stdenv.lib; {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
    description = "ESC/P-R Driver (generic driver)";
    longDescription = ''
      Epson Inkjet Printer Driver (ESC/P-R) for Linux and the
      corresponding PPD files. The list of supported printers
      can be found at http://www.openprinting.org/driver/epson-escpr/ .

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.epson-escpr ];
        };

      To setup a wireless printer, enable Avahi which provides
      printer's hostname to CUPS and nss-mdns to make this
      hostname resolvable:
        services.avahi = {
          enable = true;
          nssmdns = true;
        };'';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.linux;
  };
}
