{
  pkgs,
  buildEnv,
  runCommand,
  lib,
  stdenv,
  freebsd,
  binlore,
}:

# These are some unix tools that are commonly included in the /usr/bin
# and /usr/sbin directory under more normal distributions. Along with
# coreutils, these are commonly assumed to be available by build
# systems, but we can't assume they are available. In Nix, we list
# each program by name directly through this unixtools attribute.

# You should always try to use single binaries when available. For
# instance, if your program needs to use "ps", just list it as a build
# input, not "procps" which requires Linux.

let
  inherit (lib)
    getBin
    getOutput
    mapAttrs
    platforms
    ;

  version = "1003.1-2008";

  singleBinary =
    cmd: providers:
    let
      provider = providers.${stdenv.hostPlatform.parsed.kernel.name} or providers.linux;
      bin = "${getBin provider}/bin/${cmd}";
      manDir = "${getOutput "man" provider}/share/man";
      pname = "${cmd}-${provider.pname}";
      inherit (provider) version;
    in
    runCommand "${pname}-${version}"
      {
        inherit pname version;
        meta = {
          mainProgram = cmd;
          priority = 10;
          platforms = platforms.${stdenv.hostPlatform.parsed.kernel.name} or platforms.all;
        };
        passthru = {
          inherit provider;
        }
        // lib.optionalAttrs (builtins.hasAttr "binlore" providers) {
          binlore.out = (binlore.synthesize (getBin bins.${cmd}) providers.binlore);
        };
        preferLocalBuild = true;
      }
      ''
        if ! [ -x ${bin} ]; then
          echo Cannot find command ${cmd}
          exit 1
        fi

        mkdir -p $out/bin
        ln -s ${bin} $out/bin/${cmd}

        if [ -d ${manDir} ]; then
          manpages=($(cd ${manDir} ; find . -name '${cmd}*'))
          for manpage in "''${manpages[@]}"; do
            mkdir -p $out/share/man/$(dirname $manpage)
            ln -s ${manDir}/$manpage $out/share/man/$manpage
          done
        fi
      '';

  # more is unavailable in darwin
  # so we just use less
  more_compat =
    let
      pname = "more-${pkgs.less.pname}";
      version = pkgs.less.version;
    in
    runCommand "${pname}-${version}"
      {
        inherit pname version;
      }
      ''
        mkdir -p $out/bin
        ln -s ${pkgs.less}/bin/less $out/bin/more
      '';

  bins = mapAttrs singleBinary {
    # singular binaries
    arp = {
      linux = pkgs.net-tools;
      darwin = pkgs.darwin.network_cmds;
      freebsd = pkgs.freebsd.arp;
    };
    col = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.text_cmds;
    };
    column = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.text_cmds;
    };
    eject = {
      linux = pkgs.util-linux;
    };
    getconf = {
      linux = if stdenv.hostPlatform.libc == "glibc" then pkgs.libc else pkgs.netbsd.getconf;
      darwin = pkgs.darwin.system_cmds;
      # I don't see any obvious arg exec in the doc/manpage
      binlore = ''
        execer cannot bin/getconf
      '';
    };
    getent = {
      linux = if stdenv.hostPlatform.libc == "glibc" then pkgs.libc.getent else pkgs.netbsd.getent;
      darwin = pkgs.netbsd.getent;
      freebsd = pkgs.freebsd.getent;
      openbsd = pkgs.openbsd.getent;
    };
    getopt = {
      linux = pkgs.util-linux;
      darwin = pkgs.getopt;
    };
    fdisk = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.diskdev_cmds;
      freebsd = pkgs.freebsd.fdisk;
    };
    fsck = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.diskdev_cmds;
    };
    hexdump = {
      linux = pkgs.util-linuxMinimal;
      darwin = pkgs.darwin.shell_cmds;
    };
    hostname = {
      linux = pkgs.hostname-debian;
      darwin = pkgs.darwin.shell_cmds;
      freebsd = pkgs.freebsd.bin;
      openbsd = pkgs.openbsd.hostname;
    };
    ifconfig = {
      linux = pkgs.net-tools;
      darwin = pkgs.darwin.network_cmds;
      freebsd = pkgs.freebsd.ifconfig;
      openbsd = pkgs.openbsd.ifconfig;
    };
    killall = {
      linux = pkgs.psmisc;
      darwin = pkgs.darwin.shell_cmds;
    };
    locale = {
      linux = pkgs.glibc;
      darwin = pkgs.darwin.adv_cmds;
      freebsd = pkgs.freebsd.locale;
      # technically just targeting glibc version
      # no obvious exec in manpage
      binlore = ''
        execer cannot bin/locale
      '';
    };
    logger = {
      linux = pkgs.util-linux;
    };
    more = {
      linux = pkgs.util-linux;
      darwin = more_compat;
    };
    mount = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.diskdev_cmds;
      freebsd = freebsd.mount;
      openbsd = pkgs.openbsd.mount;
      # technically just targeting the darwin version; binlore already
      # ids the util-linux copy as 'cannot'
      # no obvious exec in manpage args; I think binlore flags 'can'
      # on the code to run `mount_<filesystem>` variants
      binlore = ''
        execer cannot bin/mount
      '';
    };
    netstat = {
      linux = pkgs.net-tools;
      darwin = pkgs.darwin.network_cmds;
      freebsd = pkgs.freebsd.netstat;
    };
    ping = {
      linux = pkgs.iputils;
      darwin = pkgs.darwin.network_cmds;
      freebsd = freebsd.ping;
    };
    ps = {
      linux = pkgs.procps;
      darwin = pkgs.darwin.ps;
      freebsd = pkgs.freebsd.bin;
      openbsd = pkgs.openbsd.ps;
      # technically just targeting procps ps (which ids as can)
      # but I don't see obvious exec in args; have yet to look
      # for underlying cause in source
      binlore = ''
        execer cannot bin/ps
      '';
    };
    quota = {
      linux = pkgs.linuxquota;
      darwin = pkgs.darwin.diskdev_cmds;
    };
    route = {
      linux = pkgs.net-tools;
      darwin = pkgs.darwin.network_cmds;
      freebsd = pkgs.freebsd.route;
      openbsd = pkgs.openbsd.route;
    };
    script = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.shell_cmds;
    };
    sysctl = {
      linux = pkgs.procps;
      darwin = pkgs.darwin.system_cmds;
      freebsd = pkgs.freebsd.sysctl;
      openbsd = pkgs.openbsd.sysctl;
    };
    top = {
      linux = pkgs.procps;
      darwin = pkgs.darwin.top;
      freebsd = pkgs.freebsd.top;
      openbsd = pkgs.openbsd.top;
      # technically just targeting procps top; haven't needed this in
      # any scripts so far, but overriding it for consistency with ps
      # override above and in procps. (procps also overrides 'free',
      # but it isn't included here.)
      binlore = ''
        execer cannot bin/top
      '';
    };
    umount = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.diskdev_cmds;
    };
    whereis = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.shell_cmds;
    };
    wall = {
      linux = pkgs.util-linux;
    };
    watch = {
      linux = pkgs.procps;

      # watch is the only command from procps that builds currently on
      # Darwin/FreeBSD. Unfortunately no other implementations exist currently!
      darwin = pkgs.callPackage ../os-specific/linux/procps-ng { };
      freebsd = pkgs.callPackage ../os-specific/linux/procps-ng { };
      openbsd = pkgs.callPackage ../os-specific/linux/procps-ng { };
    };
    write = {
      linux = pkgs.util-linux;
      darwin = pkgs.darwin.basic_cmds;
    };
    xxd = {
      linux = pkgs.tinyxxd;
      darwin = pkgs.tinyxxd;
      freebsd = pkgs.tinyxxd;
    };
  };

  makeCompat =
    pname: paths:
    buildEnv {
      inherit paths pname version;
    };

  # Compatibility derivations
  # Provided for old usage of these commands.
  compat =
    with bins;
    mapAttrs makeCompat {
      procps = [
        ps
        sysctl
        top
        watch
      ];
      util-linux = [
        fsck
        fdisk
        getopt
        hexdump
        mount
        script
        umount
        whereis
        write
        col
        column
      ];
      net-tools = [
        arp
        hostname
        ifconfig
        netstat
        route
      ];
    };
in
bins // compat
