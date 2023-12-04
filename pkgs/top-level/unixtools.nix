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
      provider = providers.${stdenv.hostPlatform.parsed.kernel.name} or providers.linux;
      bin = "${getBin provider}/bin/${cmd}";
      manpage = "${getOutput "man" provider}/share/man/man1/${cmd}.1.gz";
    in runCommand "${cmd}-${provider.name}" {
      meta = {
        mainProgram = cmd;
        priority = 10;
        platforms = lib.platforms.${stdenv.hostPlatform.parsed.kernel.name} or lib.platforms.all;
      };
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
  more_compat = runCommand "more-${pkgs.less.name}" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.less}/bin/less $out/bin/more
  '';

  bins = mapAttrs singleBinary {
    # singular binaries
    arp = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.network_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    col = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.text_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    column = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.text_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    eject = {
      linux = pkgs.util-linux;
    };
    getconf = {
      linux = if stdenv.hostPlatform.libc == "glibc" then pkgs.stdenv.cc.libc
              else pkgs.netbsd.getconf;
      darwin = pkgs.darwin.system_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    getent = {
      linux = if stdenv.hostPlatform.libc == "glibc" then pkgs.stdenv.cc.libc.getent
              else pkgs.netbsd.getent;
      darwin = pkgs.netbsd.getent;
      freebsd = pkgs.freebsd.utils;
    };
    getopt = {
      linux = pkgs.util-linux;
      darwin = pkgs.getopt;
      freebsd = pkgs.freebsd.utils;
    };
    fdisk = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.diskdev_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    fsck = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.diskdev_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    hexdump = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.shell_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    hostname = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.shell_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    ifconfig = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.network_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    killall = {
      linux = pkgs.psmisc;
      darwin = pkgs.darwin.shell_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    locale = {
      linux = pkgs.glibc;
      darwin = pkgs.darwin.adv_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    logger = {
      linux = pkgs.util-linux;
      freebsd = pkgs.freebsd.utils;
    };
    more = {
      linux = pkgs.util-linux;
      darwin = more_compat;
      freebsd = pkgs.freebsd.utils;
    };
    mount = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.diskdev_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    netstat = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.network_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    ping = {
      linux = pkgs.iputils;
      darwin = pkgs.darwin.network_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    ps = {
      linux = pkgs.procps;
      darwin = pkgs.darwin.ps;
      freebsd = pkgs.freebsd.utils;
    };
    quota = {
      linux = pkgs.linuxquota;
      darwin = pkgs.darwin.diskdev_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    route = {
      linux = pkgs.nettools;
      darwin = pkgs.darwin.network_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    script = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.shell_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    sysctl = {
      linux = pkgs.procps;
      darwin = pkgs.darwin.system_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    top = {
      linux = pkgs.procps;
      darwin = pkgs.darwin.top;
      freebsd = pkgs.freebsd.utils;
    };
    umount = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.diskdev_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    whereis = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.shell_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    wall = {
      linux = pkgs.util-linux;
      freebsd = pkgs.freebsd.utils;
    };
    watch = {
      linux = pkgs.procps;

      # watch is the only command from procps that builds currently on
      # Darwin. Unfortunately no other implementations exist currently!
      darwin = pkgs.callPackage ../os-specific/linux/procps-ng {};
      freebsd = pkgs.freebsd.utils;
    };
    write = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.basic_cmds;
      freebsd = pkgs.freebsd.utils;
    };
    xxd = {
      linux = pkgs.vim;
      darwin = pkgs.vim;
      freebsd = pkgs.freebsd.utils;
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
    util-linux = [ fsck fdisk getopt hexdump mount
                  script umount whereis write col column ];
    nettools = [ arp hostname ifconfig netstat route ];
  };
in bins // compat
