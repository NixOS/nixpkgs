{pkgs, config, ...}:

let

  acpiConfDir = pkgs.runCommand "acpi-events" {}
    ''
      ensureDir $out
      ${
        # Generate a .conf file for each event. (You can't have
        # multiple events in one config file...)
        let f = event:
          ''
            fn=$out/${event.name}.conf
            echo "event=${event.event}" > $fn
            echo "action=${pkgs.writeScript "${event.name}.sh" event.action}" >> $fn
          '';
        in pkgs.lib.concatMapStrings f events
      }
    '';

  events = [powerEvent lidEvent acEvent];

  # Called when the power button is pressed.
  powerEvent =
    { name = "power-button";
      event = "button/power.*";
      action = 
        ''
          #! ${pkgs.bash}/bin/sh
        '';
    };

  # Called when the laptop lid is opened/closed.
  lidEvent = 
    { name = "lid";
      event = "button/lid.*";
      action =
        ''
          #! ${pkgs.bash}/bin/sh

          # Suspend to RAM if the lid is closed.  (We also get this event
          # when the lid just opened, in which case we obviously don't
          # want to suspend again.) 
          if grep -q closed /proc/acpi/button/lid/LID/state; then
              sync
              echo mem > /sys/power/state
          fi
        '';
    };

  # Called when the AC power is connected or disconnected.
  acEvent =
    { name = "ac-power";
      event = "ac_adapter.*";
      action = 
        ''
          #! ${pkgs.bash}/bin/sh

          if grep -q "state:.*on-line" /proc/acpi/ac_adapter/AC/state; then
             echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
          elif grep -q "state:.*off-line" /proc/acpi/ac_adapter/AC/state; then
             echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
          fi
        '';
    };

in

{
  name = "acpid";
  
  extraPath = [pkgs.acpid];
  
  job = ''
    description "ACPI daemon"

    start on udev
    stop on shutdown

    respawn ${pkgs.acpid}/sbin/acpid --foreground --confdir ${acpiConfDir}
  '';
  
}
