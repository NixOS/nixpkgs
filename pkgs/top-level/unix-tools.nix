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
  fdisk = singleBinary "fdisk" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.diskdev_cmds;
  };
  fsck = singleBinary "fsck" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.diskdev_cmds;
  };
  hexdump = singleBinary "hexdump" {
    linux = pkgs.utillinux;
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
  more = singleBinary "more" {
    linux = pkgs.utillinux;
    darwin = more_compat;
  };
  mount = singleBinary "mount" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.diskdev_cmds;
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
  quota = singleBinary "quota" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.diskdev_cmds;
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
  top = singleBinary "top" {
    linux = pkgs.procps;
    darwin = pkgs.darwin.top;
  };
  umount = singleBinary "umount" {
    linux = pkgs.utillinux;
    darwin = pkgs.darwin.diskdev_cmds;
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
    paths = [ ps sysctl top ];
  };

  utillinux = buildEnv {
    name = "utillinux-compat";
    paths = [ fsck fdisk getopt hexdump mount
              quota script umount whereis write ];
  };

  nettools = buildEnv {
    name = "nettools-compat";
    paths = [ arp hostname ifconfig netstat route ];
  };
}
