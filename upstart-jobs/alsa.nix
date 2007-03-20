{modprobe, alsaUtils}:

let

  soundState = "/var/lib/alsa/asound.state";

in
  
{
  name = "alsa";

  extraPath = [alsaUtils];
  
  job = "
start on hardware-scan
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

  ";

}
