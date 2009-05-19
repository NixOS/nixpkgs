# this file contains all extendable options originally defined in system.nix
# TODO: split it to make it readable.
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
  inherit (pkgs.lib) mapRecordFlatten;

  activateLib = config.system.activationScripts.lib;
in

{
  require = [
    option

    # config.system.activationScripts
    ../system/activate-configuration.nix
  ];

  system = {
    build = {
      binsh = pkgs.bashInteractive;
    };

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
          pkgs.glibcLocales # needed for getent
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
        ln -sfn ${config.system.build.binsh}/bin/sh $mountPoint/bin/sh
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
        echo ${config.system.sbin.modprobe}/sbin/modprobe > /proc/sys/kernel/modprobe
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
            echo "root:x:0:0:System administrator:$rootHome:${config.system.shell}" >> /etc/passwd
            echo "root::::::::" >> /etc/shadow
            echo | passwd --stdin root
        fi
      '' [
        activateLib.defaultPath # path to touch & passwd
        activateLib.etc # for /etc
        # ?
      ];

      nix = FullDepEntry ''
        # Set up Nix.
        mkdir -p /nix/etc/nix
        ln -sfn /etc/nix.conf /nix/etc/nix/nix.conf
        chown root.nixbld /nix/store
        chmod 1775 /nix/store

        # Nix initialisation.
        mkdir -m 0755 -p \
            /nix/var/nix/gcroots \
            /nix/var/nix/temproots \
            /nix/var/nix/manifests \
            /nix/var/nix/userpool \
            /nix/var/nix/profiles \
            /nix/var/nix/db \
            /nix/var/log/nix/drvs \
            /nix/var/nix/channel-cache \
            /nix/var/nix/chroots
        mkdir -m 1777 -p /nix/var/nix/gcroots/per-user
        mkdir -m 1777 -p /nix/var/nix/profiles/per-user

        ln -sf /nix/var/nix/profiles /nix/var/nix/gcroots/
        ln -sf /nix/var/nix/manifests /nix/var/nix/gcroots/
      '' [
        activateLib.defaultPath
        activateLib.etc # /etc/nix.conf
        activateLib.users # nixbld group
      ];

      path = FullDepEntry ''
        PATH=${config.system.path}/bin:${config.system.path}/sbin:$PATH
      '' [
        activateLib.defaultPath
      ];

      setuid =
        let
          setuidPrograms = builtins.toString (
            config.security.setuidPrograms ++
            config.security.extraSetuidPrograms ++
            map (x: x.program) config.security.setuidOwners
          );

          adjustSetuidOwner = pkgs.lib.concatStrings (map
            (_entry: let entry = {
              owner = "nobody";
              group = "nogroup";
              setuid = false;
              setgid = false;
            } //_entry; in
            ''
              chown ${entry.owner}.${entry.group} $wrapperDir/${entry.program}
              chmod u${if entry.setuid then "+" else "-"}s $wrapperDir/${entry.program} 
              chmod g${if entry.setgid then "+" else "-"}s $wrapperDir/${entry.program}
            '')
            config.security.setuidOwners);

        in FullDepEntry ''
        # Make a few setuid programs work.
        save_PATH="$PATH"

        # Add the default profile to the search path for setuid executables.
        PATH="/nix/var/nix/profiles/default/sbin:$PATH"
        PATH="/nix/var/nix/profiles/default/bin:$PATH"

        wrapperDir=${config.system.wrapperDir}
        if test -d $wrapperDir; then rm -f $wrapperDir/*; fi # */
        mkdir -p $wrapperDir
        for i in ${setuidPrograms}; do
            program=$(type -tp $i)
            if test -z "$program"; then
        	# XXX: It would be preferable to detect this problem before
        	# `activate-configuration' is invoked.
        	#echo "WARNING: No executable named \`$i' was found" >&2
        	#echo "WARNING: but \`$i' was specified as a setuid program." >&2
                true
            else
                cp "$(type -tp setuid-wrapper)" $wrapperDir/$i
                echo -n "$program" > $wrapperDir/$i.real
                chown root.root $wrapperDir/$i
                chmod 4755 $wrapperDir/$i
            fi
        done

        ${adjustSetuidOwner}

        PATH="$save_PATH"
      '' [
        activateLib.path
        activateLib.users
      ];

      hostname = FullDepEntry ''
        # Set the host name.  Don't clear it if it's not configured in the
        # NixOS configuration, since it may have been set by dhclient in the
        # meantime.
        ${if config.networking.hostName != "" then
            ''hostname "${config.networking.hostName}"''
        else ''
            # dhclient won't do anything if the hostname isn't empty.
            if test "$(hostname)" = "(none)"; then
              hostname ""
            fi
        ''}
      '' [
        activateLib.path
      ];

      # The activation have to be done at the end.  Therefore, this entry
      # depends on all scripts declared in the activation library.
      activate = FullDepEntry ''
        # Make this configuration the current configuration.
        # The readlink is there to ensure that when $systemConfig = /system
        # (which is a symlink to the store), /var/run/current-system is still
        # used as a garbage collection root.
        ln -sfn "$(readlink -f "$systemConfig")" /var/run/current-system

        # Prevent the current configuration from being garbage-collected.
        ln -sfn /var/run/current-system /nix/var/nix/gcroots/current-system
      '' (mapRecordFlatten (a: v: v)
        # should be removed if this does not cause an infinite recursion.
        (activateLib // { activate = { text = ""; deps = []; }; })
      );
    };
  };
}
