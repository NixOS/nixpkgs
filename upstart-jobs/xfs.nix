{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      xfs = {

        enable = mkOption {
          default = false;
          description = "
            Whether to enable the X Font Server.
          ";
        };

      };
    };
  };
in

###### implementation


let
  configFile = ./xfs.conf;
  startingDependency = if config.services.gw6c.enable && config.services.gw6c.autorun then "gw6c" else "network-interfaces";
in

mkIf config.services.xfs.enable {

  assertions = [ { assertion = ! config.fonts.enableFontDir; message = "Please enable fontDir (fonts.enableFontDir) to use xfs."; } ];

  require = [
    options
  ];

  services = {

    extraJobs = [ (rec {
      name = "xfs";
      groups = [];
      users = [];
      job = ''
        description "X Font Server"
        start on ${startingDependency}/started
        stop on shutdown

        respawn ${pkgs.xorg.xfs}/bin/xfs -config ${configFile}
      '';
    })];
  };
}
