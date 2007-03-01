{kernel, module_init_tools, alsaUtils}:

let

  soundState = "/var/state/asound.state";

in
  
{
  name = "alsa";
  
  job = "
start on hardware-scan
stop on shutdown

script

    # Load some additional modules.
    export MODULE_DIR=${kernel}/lib/modules/
    for mod in snd_pcm_oss; do
        ${module_init_tools}/sbin/modprobe $mod || true
    done

    # Restore the sound state.
    ${alsaUtils}/sbin/alsactl -f ${soundState} restore

end script

stop script

    # Save the sound state.
    ${alsaUtils}/sbin/alsactl -f ${soundState} store

end script

  ";

}
