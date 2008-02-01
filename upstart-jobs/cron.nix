{pkgs, config}:

let

  systemCronJobs = config.services.cron.systemCronJobs;

  systemCronJobsFile = pkgs.writeText "system-crontab" ''
    SHELL=${pkgs.bash}/bin/sh
    PATH=${pkgs.coreutils}/bin
    MAILTO=
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

    respawn ${pkgs.cron}/sbin/cron -n
  '';
}
