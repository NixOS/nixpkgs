rec {

  devices = import ./devices.nix;

  disks = import ./disks.nix;

  networking = import ./networking.nix;

  systemServices = [
    terminalRunner
    syslogServer
    dhcpClient
    sshServer
    subversionServer
  ];
  
  systemInit = {
    inherit devices disks networking;
    inherit systemServices;
  };

  kernel = import ... {
    externalModules = [nvidia vmware ...];
  }

}
