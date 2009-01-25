{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption
    mergeEnableOption mergeListOption;

  options = {
    networking = {
      useDHCP = mkOption {
        default = true;
        merge = mergeEnableOption;
        description = "
          Whether to use DHCP to obtain an IP adress and other
          configuration for all network interfaces that are not manually
          configured.
        ";
      };
  
      interfaces = mkOption {
        default = [];
        merge = mergeListOption;
        example = [
          { name = "eth0";
            ipAddress = "131.211.84.78";
            subnetMask = "255.255.255.128";
          }
        ];
        description = "
          The configuration for each network interface.  If
          <option>networking.useDHCP</option> is true, then each interface
          not listed here will be configured using DHCP.
        ";
      };
    };
  };
in

###### implementation
let
  ifEnable = arg:
    if config.networking.useDHCP then arg
    else if builtins.isList arg then []
    else if builtins.isAttrs arg then {}
    else null;

  inherit (pkgs) nettools dhcp lib;

  # Don't start dhclient on explicitly configured interfaces.
  ignoredInterfaces = ["lo"] ++
    map (i: i.name) (lib.filter (i: i ? ipAddress) config.networking.interfaces);

  stateDir = "/var/lib/dhcp"; # Don't use /var/state/dhcp; not FHS-compliant.
in

{
  require = [
    # (import ../upstart-jobs/default.nix)
    options
  ];

  services = {
    extraJobs = ifEnable [{
      name = "dhclient";

      extraPath = [dhcp];
  
      job = "
description \"DHCP client\"

start on network-interfaces/started
stop on network-interfaces/stop

env PATH_DHCLIENT_SCRIPT=${dhcp}/sbin/dhclient-script

script
    export PATH=${nettools}/sbin:$PATH

    # Determine the interface on which to start dhclient.
    interfaces=

    for i in $(cd /sys/class/net && ls -d *); do
        if ! for j in ${toString ignoredInterfaces}; do echo $j; done | grep -F -x -q \"$i\"; then
            echo \"Running dhclient on $i\"
            interfaces=\"$interfaces $i\"
        fi
    done

    if test -z \"$interfaces\"; then
        echo 'No interfaces on which to start dhclient!'
        exit 1
    fi

    mkdir -m 755 -p ${stateDir}

    exec ${dhcp}/sbin/dhclient -d $interfaces -e \"PATH=$PATH\" -lf ${stateDir}/dhclient.leases
end script
      ";
    }];
  };
}

