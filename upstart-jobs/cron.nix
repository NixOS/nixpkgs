{pkgs, config}:

let

  # !!! This should be defined somewhere else.
  locatedb = "/var/cache/locatedb";
  
  updatedbCmd =
    "${config.services.locate.period}  root  " +
    "mkdir -m 0755 -p $(dirname ${locatedb}) && " +
    "nice -n 19 ${pkgs.utillinux}/bin/ionice -c 3 " +
    "updatedb --localuser=nobody --output=${locatedb} > /var/log/updatedb 2>&1";
  

  # Put all the system cronjobs together.
  systemCronJobs =
    config.services.cron.systemCronJobs ++
    pkgs.lib.optional config.services.locate.enable updatedbCmd;

  systemCronJobsFile = pkgs.writeText "system-crontab" ''
    SHELL=${pkgs.bash}/bin/sh
    PATH=${pkgs.coreutils}/bin:${pkgs.findutils}/bin:${pkgs.gnused}/bin:${pkgs.su}/bin
    MAILTO="${config.services.cron.mailto}"
    ${pkgs.lib.concatStrings (map (job: job + "\n") systemCronJobs)}
  '';

in
  
{
  name = "cron";
  
  extraEtc = [
    # The system-wide crontab.
    { source = systemCronJobsFile;
      target = "crontab";
      mode = "0600"; # Cron requires this.
    }
  ];

  job = ''
    description "Cron daemon"

    start on startup
    stop on shutdown

    # Needed to interpret times in the local timezone.
    env TZ=${config.time.timeZone}

    respawn ${pkgs.cron}/sbin/cron -n
  '';
}
