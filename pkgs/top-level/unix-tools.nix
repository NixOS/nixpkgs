{ pkgs, buildEnv, runCommand, hostPlatform }:

let

  singleBinary = cmd: providers:
    if builtins.hasAttr hostPlatform.parsed.kernel.name providers then
      runCommand cmd {} ''
        mkdir -p $out/bin

        if ! [ -x "${providers.${hostPlatform.parsed.kernel.name}}/bin/${cmd}" ]; then
          echo "Cannot find command ${cmd}"
          exit 1
        fi

        ln -s ${providers.${hostPlatform.parsed.kernel.name}}/bin/${cmd} $out/bin/${cmd}
      ''
    else throw "${hostPlatform.parsed.kernel.name} does not have ${cmd}";

in rec {
  arp = singleBinary "arp" {
    linux = pkgs.nettools;
    darwin = pkgs.darwin.network_cmds;
  };
  getopt = singleBinary "getopt" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.shell_cmds;
  };
  hexdump = singleBinary "hexdump" {
    linux = pkgs.procps;
    darwin = pkgs.darwin.shell_cmds;
  };
  hostname = singleBinary "hostname" {
    linux = pkgs.nettools;
    darwin = pkgs.darwin.shell_cmds;
  };
  ifconfig = singleBinary "ifconfig" {
    linux = pkgs.nettools;
    darwin = pkgs.darwin.network_cmds;
  };
  netstat = singleBinary "netstat" {
    linux = pkgs.nettools;
    darwin = pkgs.darwin.network_cmds;
  };
  ping = singleBinary "ping" {
    linux = pkgs.iputils;
    darwin = pkgs.darwin.network_cmds;
  };
  ps = singleBinary "ps" {
    linux = pkgs.procps;
    darwin = pkgs.darwin.adv_cmds;
  };
  route = singleBinary "route" {
    linux = pkgs.nettools;
    darwin = pkgs.darwin.network_cmds;
  };
  script = singleBinary "script" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.shell_cmds;
  };
  sysctl = singleBinary "sysctl" {
    linux = pkgs.procps;
    darwin = pkgs.darwin.system_cmds;
  };
  whereis = singleBinary "whereis" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.shell_cmds;
  };
  write = singleBinary "write" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.basic_cmds;
  };

  # Compatibility derivations

  procps = buildEnv {
    name = "procps-compat";
    paths = [ sysctl ps ];
  };

  utillinux = buildEnv {
    name = "utillinux-compat";
    paths = [ getopt hexdump script whereis write ];
  };

  nettools = buildEnv {
    name = "nettools-compat";
    paths = [ arp hostname netstat route ];
  };
}
