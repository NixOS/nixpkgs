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
    };
  };
}
