# ALSA sound support.
{pkgs, config}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    sound = {

      enable = mkOption {
        default = true;
        description = "
          Whether to enable ALSA sound.
        ";
        merge = pkgs.lib.mergeEnableOption;
      };

    };
  };
in

###### implementation
let
  ifEnable = pkgs.lib.ifEnable config.sound.enable;

  # dangerous !
  modprobe = config.system.sbin.modprobe;
  inherit (pkgs) alsaUtils;

  soundState = "/var/lib/alsa/asound.state";

  # Alsalib seems to require the existence of this group, even if it's
  # not used (e.g., doesn't own any devices).
  group = {
    name = "audio";
    gid = (import ../system/ids.nix).gids.audio;
  };

  job = {
    name = "alsa";

    job = ''
      start on udev
      stop on shutdown

      start script

          mkdir -m 0755 -p $(dirname ${soundState})

          # Load some additional modules.
          for mod in snd_pcm_oss; do
              ${modprobe}/sbin/modprobe $mod || true
          done

          # Restore the sound state.
          ${alsaUtils}/sbin/alsactl -f ${soundState} restore

      end script

      respawn sleep 1000000 # !!! hack

      stop script

          # Save the sound state.
          ${alsaUtils}/sbin/alsactl -f ${soundState} store

      end script
    '';
  };
in

{
  require = [
    (import ../upstart-jobs/default.nix) # config.services.extraJobs
    # (import ../system/user.nix) # users.*
    # (import ?) # config.environment.extraPackages
    options
  ];

  environment = {
    extraPackages = ifEnable [alsaUtils];
  };

  users = {
    extraGroups = ifEnable [group];
  };

  services = {
    extraJobs = ifEnable [job];
  };
}
