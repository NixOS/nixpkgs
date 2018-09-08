{ stdenv, fetchurl, cups }:

stdenv.mkDerivation rec {
  name = "epson-escpr-${version}";
  version = "1.6.16";

  src = fetchurl {
    url = "https://download3.ebz.epson.net/dsc/f/03/00/06/41/54/29588ed107f800e5bc3f91706661567efb369c1c/epson-inkjet-printer-escpr-1.6.16-1lsb3.2.tar.gz";
    sha256 = "0v9mcih3dg3ws18hdcgm014k97hv6imga39hy2a84gnc6badp6n6";
  };

  patches = [ ./cups-filter-ppd-dirs.patch ];

  buildInputs = [ cups ];

  meta = with stdenv.lib; {
    homepage = http://download.ebz.epson.net/dsc/search/01/search/;
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
