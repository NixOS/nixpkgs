{ stdenv, fetchurl, cups }:

let
  version = "1.6.4";
in
  stdenv.mkDerivation {

    name = "epson-escpr-${version}";
  
    src = fetchurl {
      url = "https://download3.ebz.epson.net/dsc/f/03/00/04/37/97/88177bc0dc7025905eae4a0da1e841408f82e33c/epson-inkjet-printer-escpr-1.6.4-1lsb3.2.tar.gz"; 
      sha256 = "76c66461a30be82b9cc37d663147a72f488fe060ef54578120602bb87a3f7754"; 
    }; 

    patches = [ ./cups-filter-ppd-dirs.patch ]; 

    buildInputs = [ cups ];

    meta = with stdenv.lib; {
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
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ artuuge ];
      platforms = platforms.linux;
    };

  }
