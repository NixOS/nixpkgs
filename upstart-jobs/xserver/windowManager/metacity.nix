{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.metacity;
  xorg = config.services.xserver.package;
  gnome = pkgs.gnome;

  option = { services = { xserver = { windowManager = {

    metacity = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the metacity window manager.";
      };

    };

  }; }; }; };
in

mkIf cfg.enable {
  require = option;

  services = {
    xserver = {

      windowManager = {
        session = [{
          name = "metacity";
          start = ''
            env LD_LIBRARY_PATH=${xorg.libX11}/lib:${xorg.libXext}/lib:/usr/lib/
            # !!! Hack: load the schemas for Metacity.
            GCONF_CONFIG_SOURCE=xml::~/.gconf ${gnome.GConf}/bin/gconftool-2 \
              --makefile-install-rule ${gnome.metacity}/etc/gconf/schemas/*.schemas # */
            ${gnome.metacity}/bin/metacity &
            waitPID=$!
          '';
        }];
      };

    };
  };

  environment = {
    extraPackages = [ gnome.metacity ];
  };
}
