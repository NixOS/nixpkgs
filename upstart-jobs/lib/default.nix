# This file defines functions to handle upstart-jobs.
{pkgs, config, ...}:

let
  inherit (pkgs.lib) filter findSingle;
  jobs = config.services.extraJobs;

  primaryEvents = [
    "startup"
    "shutdown"
    "never"
  ];

  upstartJobsTools = rec {
    exists = name:
      let
        found = filter
          (j: j ? name && j.name == name)
          (jobs ++ map (name: {inherit name;}) primaryEvents);
      in found != [];

    check = name:
      if exists name then
        name
      else
        abort "Undefined upstart job name: ${name}.";
  };
in

{
  services = {
    tools = {
      upstartJobs = upstartJobsTools;
    };
  };
}
