{
  lib,
  newScope,
  pkgs,
  config,
}:

cockpit:
(lib.makeScope newScope (self: {
  inherit cockpit;

  cockpit-machines = self.callPackage ../servers/monitoring/cockpit/cockpit-machines { };
}))
