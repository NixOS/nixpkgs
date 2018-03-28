{ pkgs, buildEnv, runCommand, hostPlatform }:

# These are some unix tools that are commonly included in the /usr/bin
# and /usr/sbin directory under more normal distributions. Along with
# coreutils, these are commonly assumed to be available by build
# systems, but we can't assume they are available. In Nix, we list
# each program by name directly through this unixtools attribute.

# You should always try to use single binaries when available. For
# instance, if your program needs to use "ps", just list it as a build
# input, not "procps" which requires Linux.

let

  singleBinary = cmd: providers: let
      provider = "${providers.${hostPlatform.parsed.kernel.name} or "missing-package"}/bin/${cmd}";
    in runCommand cmd {
      meta.platforms = map (n: { kernel.name = n; }) (pkgs.lib.attrNames providers);
    } ''
      mkdir -p $out/bin

      if ! [ -x "${provider}" ]; then
        echo "Cannot find command ${cmd}"
        exit 1
      fi

      ln -s "${provider}" "$out/bin/${cmd}"
    '';

in rec {

  # more is unavailable in darwin
  # just use less
  more_compat = runCommand "more" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.less}/bin/less $out/bin/more
  '';

  # singular binaries
  arp = singleBinary "arp" {
    linux = pkgs.nettools;
    darwin = pkgs.darwin.network_cmds;
  };
  eject = singleBinary "eject" {
    linux = pkgs.utillinux;
  };
  getopt = singleBinary "getopt" {
    linux = pkgs.utillinux;
    darwin = pkgs.getopt;
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
  logger = singleBinary "logger" {
    linux = pkgs.utillinux;
  };
  modprobe = singleBinary "modprobe" {
    linux = pkgs.utillinux;
  };
  more = singleBinary "more" {
    linux = pkgs.utillinux;
    darwin = more_compat;
  };
  mount = singleBinary "mount" {
    linux = pkgs.utillinux;
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
    darwin = pkgs.darwin.ps;
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
  umount = singleBinary "umount" {
    linux = pkgs.utillinux;
  };
  whereis = singleBinary "whereis" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.shell_cmds;
  };
  wall = singleBinary "wall" {
    linux = pkgs.utillinux;
  };
  write = singleBinary "write" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.basic_cmds;
  };

  # Compatibility derivations
  # Provided for old usage of these commands.

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
