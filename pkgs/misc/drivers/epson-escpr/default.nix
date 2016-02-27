{ stdenv, fetchurl, cups }:

let
  version = "1.6.3";
in
  stdenv.mkDerivation {

    name = "epson-escpr-${version}";
  
    src = fetchurl {
      url = "https://download3.ebz.epson.net/dsc/f/03/00/04/33/53/0177a44361d3dfeacf7f15ff4a347cef373688da/epson-inkjet-printer-escpr-1.6.3-1lsb3.2.tar.gz";
      sha256 = "4988479ce7dd5513bfa1cce4a83f82348572d8d69d6aa3b2c6e154a58a04ad86"; 
    }; 

    patches = [ ./cups-filter-ppd-dirs.patch ]; 

    buildInputs = [ cups ];

    meta = {
      homepage = https://github.com/artuuge/NixOS-files/;
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
      license = stdenv.lib.licenses.gpl3Plus;
    };

  }
