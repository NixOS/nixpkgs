{pkgs, config, ...}:

###### implementation

{
  services = {
    extraJobs = [{
      name = "maintenance-shell";
      
      job = ''
          start on maintenance
          start on stalled
          
          script
              exec < /dev/tty1 > /dev/tty1 2>&1
              echo \"\"
              echo \"<<< MAINTENANCE SHELL >>>\"
              echo \"\"
              exec ${pkgs.bash}/bin/sh
          end script
      '';
  }];
  };
}
