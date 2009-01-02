# this file contains all extendable options originally defined in system.nix
{pkgs, config, ...}:

let
  inherit (pkgs.stringsWithDeps) noDepEntry FullDepEntry PackEntry;

  activateLib = config.system.activationScripts.lib;
in

{
  require = [
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
