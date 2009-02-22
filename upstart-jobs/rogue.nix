{pkgs, config}: 

# Show rogue game on tty8
# Originally used only by installation CD

let
  inherit (pkgs.lib) mkOption;
  options = {
    services = {
      rogue = {
        enable = mkOption {
	  default = false;
	  description = "
	    Whether to run rogue
	  ";
	};
	ttyNumber = mkOption {
	  default = "8";
	  description = "
	    TTY number name to show the manual on
	  ";
	};
      };
    };
  };

inherit (pkgs.lib) optional;

inherit (config.services.rogue) enable ttyNumber;

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
      name = "rogue";

      job = ''
        description "rogue game"
	
	start on udev
	stop on shutdown
	respawn ${pkgs.rogue}/bin/rogue < /dev/tty${toString ttyNumber} > /dev/tty${toString ttyNumber} 2>&1
      '';
    };
    ttyBackgrounds = {
      specificThemes = optional enable {
        tty = ttyNumber;
	theme = pkgs.themes "theme-gnu";
      };
    };
    mingetty = {
      helpLine = if enable then "\nPress <Alt-F${toString ttyNumber}> to play rogue." else "";
    };
  };
}
