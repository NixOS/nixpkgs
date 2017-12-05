{ stdenv, fetchurl, cups }:

let
  version = "1.6.12";
in
  stdenv.mkDerivation {

    name = "epson-escpr-${version}";
  
    src = fetchurl {

      url = "https://download3.ebz.epson.net/dsc/f/03/00/05/46/21/01534966894f35247dac8c8ef0a0a9c94d1c8b40/epson-inkjet-printer-escpr-1.6.12-1lsb3.2.tar.gz";
      sha256 = "3773e74a0c4debf202eb9ad0aa31c6614a93d6170484ff660c14e99f8698cfda";
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
