{ pkgs, buildEnv, runCommand, hostPlatform, lib
, stdenv }:

# These are some unix tools that are commonly included in the /usr/bin
# and /usr/sbin directory under more normal distributions. Along with
# coreutils, these are commonly assumed to be available by build
# systems, but we can't assume they are available. In Nix, we list
# each program by name directly through this unixtools attribute.

# You should always try to use single binaries when available. For
# instance, if your program needs to use "ps", just list it as a build
# input, not "procps" which requires Linux.

let
  version = "1003.1-2008";

  singleBinary = cmd: providers: let
      provider = "${lib.getBin providers.${hostPlatform.parsed.kernel.name}}/bin/${cmd}";
    in runCommand "${cmd}-${version}" {
      meta.platforms = map (n: { kernel.name = n; }) (pkgs.lib.attrNames providers);
    } ''
      if ! [ -x "${provider}" ]; then
        echo "Cannot find command ${cmd}"
        exit 1
      fi

      install -D "${provider}" "$out/bin/${cmd}"
    '';

  # more is unavailable in darwin
  # just use less
  more_compat = runCommand "more-${version}" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.less}/bin/less $out/bin/more
  '';

  bins = lib.mapAttrs singleBinary {
    # singular binaries
    arp = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.network_cmds;
    };
    col = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.text_cmds;
    };
    eject = {
      linux = pkgs.utillinux;
    };
    getconf = {
      linux = if hostPlatform.libc == "glibc" then lib.getBin pkgs.glibc
              else pkgs.netbsd.getconf;
      darwin = pkgs.darwin.system_cmds;
    };
    getent = {
      linux = if hostPlatform.libc == "glibc" then lib.getBin pkgs.glibc
              else pkgs.netbsd.getent;
      darwin = pkgs.netbsd.getent;
    };
    getopt = {
      linux = pkgs.utillinux;
      darwin = pkgs.getopt;
    };
    fdisk = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.diskdev_cmds;
    };
    fsck = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.diskdev_cmds;
    };
    hexdump = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.shell_cmds;
    };
    hostname = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.shell_cmds;
    };
    ifconfig = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.network_cmds;
    };
    killall = {
      linux = pkgs.psmisc;
      darwin = pkgs.darwin.shell_cmds;
    };
    locale = {
      linux = pkgs.glibc;
      darwin = pkgs.netbsd.locale;
    };
    logger = {
      linux = pkgs.utillinux;
    };
    more = {
      linux = pkgs.utillinux;
      darwin = more_compat;
    };
    mount = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.diskdev_cmds;
    };
    netstat = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.network_cmds;
    };
    ping = {
      linux = pkgs.iputils;
      darwin = pkgs.darwin.network_cmds;
    };
    ps = {
      linux = pkgs.procps;
      darwin = pkgs.darwin.ps;
    };
    quota = {
      linux = pkgs.linuxquota;
      darwin = pkgs.darwin.diskdev_cmds;
    };
    route = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.network_cmds;
    };
    script = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.shell_cmds;
    };
    sysctl = {
      linux = pkgs.procps;
      darwin = pkgs.darwin.system_cmds;
    };
    top = {
      linux = pkgs.procps;
      darwin = pkgs.darwin.top;
    };
    umount = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.diskdev_cmds;
    };
    whereis = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.shell_cmds;
    };
    wall = {
      linux = pkgs.utillinux;
    };
    write = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.basic_cmds;
    };
  };

  makeCompat = name': value: buildEnv {
    name = name' + "-compat-${version}";
    paths = value;
  };

  # Compatibility derivations
  # Provided for old usage of these commands.
  compat = with bins; lib.mapAttrs makeCompat {
    procps = [ ps sysctl top ];
    utillinux = [ fsck fdisk getopt hexdump mount
                  script umount whereis write col ];
    nettools = [ arp hostname ifconfig netstat route ];
  };
in bins // compat
