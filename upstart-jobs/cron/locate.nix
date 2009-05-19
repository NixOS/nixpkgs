{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {
      locate = {

        enable = mkOption {
          default = false;
          example = true;
          description = ''
            If enabled, NixOS will periodically update the database of
            files used by the <command>locate</command> command.
          '';
        };

        period = mkOption {
          default = "15 02 * * *";
          description = ''
            This option defines (in the format used by cron) when the
            locate database is updated.
            The default is to update at 02:15 (at night) every day.
          '';
        };

      };

    };
  };
in

###### implementation
let
  locatedb = "/var/cache/locatedb";
  
  updatedbCmd =
    "${config.services.locate.period}  root  " +
    "mkdir -m 0755 -p $(dirname ${locatedb}) && " +
    "nice -n 19 ${pkgs.utillinux}/bin/ionice -c 3 " +
    "updatedb --localuser=nobody --output=${locatedb} > /var/log/updatedb 2>&1";
in

{
  require = [
    ../../upstart-jobs/cron.nix # config.services.cron
    options
  ];

  services = {
    cron = {
      systemCronJobs =
        pkgs.lib.optional
          config.services.locate.enable
          updatedbCmd;
    };
  };
}
