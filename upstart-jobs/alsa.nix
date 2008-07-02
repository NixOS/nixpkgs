{modprobe, alsaUtils}:

let

  soundState = "/var/lib/alsa/asound.state";

in
  
{
  name = "alsa";

  extraPath = [alsaUtils];

  # Alsalib seems to require the existence of this group, even if it's
  # not used (e.g., doesn't own any devices).
  groups = [
    { name = "audio";
      gid = (import ../system/ids.nix).gids.audio;
    }
  ];

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

}
