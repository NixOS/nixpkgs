{pkgs, config, ...}: 

# Show the NixOS manual on tty7
# Originally used only by installation CD

let
  inherit (pkgs.lib) mkOption;
  options = {
    services = {
      showManual = {
        enable = mkOption {
	  default = false;
	  description = "
	    Whether to show the NixOS manual on the tty7
	  ";
	};
	ttyNumber = mkOption {
	  default = "7";
	  description = "
	    TTY number name to show the manual on
	  ";
	};
	browserPackage = mkOption {
	  default = pkgs.w3m;
	  description = "
	    Package containing the browser to be used
	  ";
	};
	browserCommand = mkOption {
	  default = "bin/w3m";
	  description = "
	    Command (command path is relative to browserPackage) to run the browser
	  ";
	};
	manualFile = mkOption {
	  default = null; 
	  description = "
	    NixOS manual HTML file
	  ";
	};
      };
    };
  };

inherit(pkgs.lib) optional;

inherit (config.services.showManual) enable ttyNumber browserPackage browserCommand 
  manualFile;
	  
realManualFile = if manualFile == null then 
  (import ../doc/manual {nixpkgs = pkgs;})+"/manual.html"
else manualFile;

in

{
  require = [
    options
  ];

  boot = {
    extraTTYs = optional enable ttyNumber;
  };
  
  services = {
    extraJobs = optional enable {
      name = "showManual";

      job = ''
        description "NixOS manual"
	
	start on udev
	stop on shutdown
	respawn ${browserPackage}/${browserCommand} ${realManualFile} < /dev/tty${toString ttyNumber} > /dev/tty${toString ttyNumber} 2>&1
      '';
    };
    ttyBackgrounds = {
      specificThemes = optional enable {
        tty = ttyNumber;
	theme = pkgs.themes "green";
      };
    };
    mingetty = {
      helpLine = if enable then "\nPress <Alt-F${toString ttyNumber}> for NixOS manual." else "";
    };
  };
}
