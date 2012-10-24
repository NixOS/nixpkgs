{ pkgs, ... }:

{

  machine =
    { config, pkgs, ... }:

    { services.portmap.enable = true; };

  testScript =
    ''
       # The `portmap' service must be registered once for TCP and once for
       # UDP.
       $machine->succeed("test `rpcinfo -p | grep portmapper | wc -l` -eq 2");
    '';

}
