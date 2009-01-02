# this file contains all extendable options originally defined in system.nix
{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  option = {
    system = {
      build = mkOption {
        default = {};
        description = ''
          Attribute set of derivation used to setup the system.  The system
          is built by aggregating all derivations.
        '';
        apply = components: components // {
          # all components have to build directories
          result = pkgs.buildEnv {
            name = "system";
            paths = pkgs.lib.mapRecordFlatten (n: v: v) components;
          };
        };
      };

      shell = mkOption {
        default = "/var/run/current-system/sw/bin/bash";
        description = ''
          You should not redefine this option unless you want to change the
          bash version for security issues.
        '';
        merge = list:
          assert list != [] && builtins.tail list == [];
          builtins.head list;
      };

      wrapperDir = mkOption {
        default = "/var/setuid-wrappers";
        description = ''
          You should not redefine this option unless you want to change the
          path for security issues.
        '';
      };

      overridePath = mkOption {
        default = [];
        description = ''
          You should not redefine this option unless you have trouble with a
          package define in <varname>path</varname>.
        '';
      };

      path = mkOption {
        default = [];
        description = ''
          The packages you want in the boot environment.
        '';
        apply = list: pkgs.buildEnv {
          name = "system-path";
          paths = config.system.overridePath ++ list;

          # Note: We need `/lib' to be among `pathsToLink' for NSS modules
          # to work.
          inherit (config.environment) pathsToLink;

          ignoreCollisions = true;
        };
      };

    };
  };
in

###### implementation
let
  inherit (pkgs.stringsWithDeps) noDepEntry FullDepEntry PackEntry;

  activateLib = config.system.activationScripts.lib;
in

{
  require = [
    option

    # config.system.activationScripts
    (import ../system/activate-configuration.nix)
  ];

  system = {
    activationScripts = {
      systemConfig = noDepEntry ''
        systemConfig="$1"
        if test -z "$systemConfig"; then
          systemConfig="/system" # for the installation CD
        fi
      '';

      defaultPath =
        let path = [
          pkgs.coreutils pkgs.gnugrep pkgs.findutils
          pkgs.glibc # needed for getent
          pkgs.pwdutils
        ]; in noDepEntry ''
        export PATH=/empty
        for i in ${toString path}; do
          PATH=$PATH:$i/bin:$i/sbin;
        done
      '';

      stdio = FullDepEntry ''
        # Needed by some programs.
        ln -sfn /proc/self/fd /dev/fd
        ln -sfn /proc/self/fd/0 /dev/stdin
        ln -sfn /proc/self/fd/1 /dev/stdout
        ln -sfn /proc/self/fd/2 /dev/stderr
      '' [
        activateLib.defaultPath # path to ln
      ];

      binsh = FullDepEntry ''
        # Create the required /bin/sh symlink; otherwise lots of things
        # (notably the system() function) won't work.
        mkdir -m 0755 -p $mountPoint/bin
        ln -sfn @bash@/bin/sh $mountPoint/bin/sh
      '' [
        activateLib.defaultPath # path to ln & mkdir
        activateLib.stdio # ?
      ];

      modprobe = FullDepEntry ''
        # Allow the kernel to find our wrapped modprobe (which searches in the
        # right location in the Nix store for kernel modules).  We need this
        # when the kernel (or some module) auto-loads a module.
        # !!! maybe this should only happen at boot time, since we shouldn't
        # use modules that don't match the running kernel.
        echo @modprobe@/sbin/modprobe > /proc/sys/kernel/modprobe
      '' [
        # ?
      ];

      var = FullDepEntry ''
        # Various log/runtime directories.
        mkdir -m 0755 -p /var/run
        mkdir -m 0755 -p /var/run/console # for pam_console

        touch /var/run/utmp # must exist
        chmod 644 /var/run/utmp

        mkdir -m 0755 -p /var/run/nix/current-load # for distributed builds
        mkdir -m 0700 -p /var/run/nix/remote-stores

        mkdir -m 0755 -p /var/log

        touch /var/log/wtmp # must exist
        chmod 644 /var/log/wtmp

        touch /var/log/lastlog
        chmod 644 /var/log/lastlog

        mkdir -m 1777 -p /var/tmp


        # Empty, read-only home directory of many system accounts.
        mkdir -m 0555 -p /var/empty
      '' [
        activateLib.defaultPath # path to mkdir & touch & chmod
      ];

      rootPasswd = FullDepEntry ''
        # If there is no password file yet, create a root account with an
        # empty password.
        if ! test -e /etc/passwd; then
            rootHome=/root
            touch /etc/passwd; chmod 0644 /etc/passwd
            touch /etc/group; chmod 0644 /etc/group
            touch /etc/shadow; chmod 0600 /etc/shadow
            # Can't use useradd, since it complains that it doesn't know us
            # (bootstrap problem!).
            echo "root:x:0:0:System administrator:$rootHome:@defaultShell@" >> /etc/passwd
            echo "root::::::::" >> /etc/shadow
            echo | passwd --stdin root
        fi
      '' [
        activateLib.defaultPath # path to touch & passwd
        activateLib.etc # for /etc
        # ?
      ];
    };
  };
}
