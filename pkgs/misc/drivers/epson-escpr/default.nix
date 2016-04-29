{ stdenv, fetchurl, cups }:

let
  version = "1.6.5";
in
  stdenv.mkDerivation {

    name = "epson-escpr-${version}";
  
    src = fetchurl {
      url = "https://download3.ebz.epson.net/dsc/f/03/00/04/54/27/b73564748bfde7b7ce625e20d4a3257d447bec79/epson-inkjet-printer-escpr-1.6.5-1lsb3.2.tar.gz"; 
      sha256 = "1cd9e0506bf181e1476bd8305f1c6b8dbc4354eab9415d0d5529850856129e4c"; 
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
      '';
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ artuuge ];
      platforms = platforms.linux;
    };

  }
