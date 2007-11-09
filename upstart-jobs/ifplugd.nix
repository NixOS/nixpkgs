{ifplugd, config, writeScript, bash}:

let

  # The ifplugd action script, which is called whenever the link
  # status changes (i.e., a cable is plugged in or unplugged).  We do
  # nothing when a cable is unplugged.  When a cable is plugged in, we
  # restart dhclient, which will hopefully give us a new IP address
  # if appropriate.
  plugScript = writeScript "ifplugd.action" "#! ${bash}/bin/sh
    if test \"$2\" = up; then
      initctl stop dhclient
      sleep 1
      initctl start dhclient
    fi
  ";

in 

{
  name = "ifplugd";

  extraPath = [ifplugd];
  
  job = "
description \"Network interface connectivity monitor\"

start on network-interfaces/started
stop on network-interfaces/stop

respawn ${ifplugd}/sbin/ifplugd --no-daemon --no-startup --no-shutdown \\
    ${if config.networking.interfaceMonitor.beep then "" else "--no-beep"} \\
    --run ${plugScript}";
  
}
