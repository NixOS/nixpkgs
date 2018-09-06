{ pkgs, buildEnv, runCommand, lib, stdenv }:

# These are some unix tools that are commonly included in the /usr/bin
# and /usr/sbin directory under more normal distributions. Along with
# coreutils, these are commonly assumed to be available by build
# systems, but we can't assume they are available. In Nix, we list
# each program by name directly through this unixtools attribute.

# You should always try to use single binaries when available. For
# instance, if your program needs to use "ps", just list it as a build
# input, not "procps" which requires Linux.

with lib;

let
  version = "1003.1-2008";

  singleBinary = cmd: providers: let
      provider = providers.${stdenv.hostPlatform.parsed.kernel.name};
      bin = "${getBin provider}/bin/${cmd}";
      manpage = "${getOutput "man" provider}/share/man/man1/${cmd}.1.gz";
    in runCommand "${cmd}-${version}" {
      meta.platforms = map (n: { kernel.name = n; }) (attrNames providers);
      passthru = { inherit provider; };
      preferLocalBuild = true;
    } ''
      if ! [ -x ${bin} ]; then
        echo Cannot find command ${cmd}
        exit 1
      fi

      mkdir -p $out/bin
      ln -s ${bin} $out/bin/${cmd}

      if [ -f ${manpage} ]; then
        mkdir -p $out/share/man/man1
        ln -s ${manpage} $out/share/man/man1/${cmd}.1.gz
      fi
    '';

  # more is unavailable in darwin
  # so we just use less
  more_compat = runCommand "more-${version}" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.less}/bin/less $out/bin/more
  '';

  bins = mapAttrs singleBinary {
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
      linux = if stdenv.hostPlatform.libc == "glibc" then pkgs.glibc
              else pkgs.netbsd.getconf;
      darwin = pkgs.darwin.system_cmds;
    };
    getent = {
      linux = if stdenv.hostPlatform.libc == "glibc" then pkgs.glibc
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
    watch = {
      linux = pkgs.procps;

      # watch is the only command from procps that builds currently on
      # Darwin. Unfortunately no other implementations exist currently!
      darwin = pkgs.callPackage ../os-specific/linux/procps-ng {};
    };
    write = {
      linux = pkgs.utillinux;
      darwin = pkgs.darwin.basic_cmds;
    };
    xxd = {
      linux = pkgs.vim;
      darwin = pkgs.vim;
    };
  };

  makeCompat = pname: paths:
    buildEnv {
      name = "${pname}-${version}";
      inherit paths;
    };

  # Compatibility derivations
  # Provided for old usage of these commands.
  compat = with bins; lib.mapAttrs makeCompat {
    procps = [ ps sysctl top watch ];
    utillinux = [ fsck fdisk getopt hexdump mount
                  script umount whereis write col ];
    nettools = [ arp hostname ifconfig netstat route ];
  };
in bins // compat
