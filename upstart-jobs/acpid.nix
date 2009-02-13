{pkgs, config, ...}:

let

  acpiConfDir = pkgs.runCommand "acpi-events" {}
    ''
      ensureDir $out
      ln -s ${acpiConfFile} $out/events.conf
    '';

  acpiConfFile = pkgs.writeText "acpi.conf"
    ''
      event=button/power.*
      action=${powerEventHandler} "%e"

      event=button/lid.*
      action=${lidEventHandler} "%e"

      event=ac_adapter.*
      action=${acEventHandler} "%e"
    '';

  # Called when the power button is pressed.
  powerEventHandler = pkgs.writeScript "acpi-power.sh"
    ''
      #! ${pkgs.bash}/bin/sh
      # Suspend to RAM.
      #echo mem > /sys/power/state
    '';

  # Called when the laptop lid is opened/closed.
  lidEventHandler = pkgs.writeScript "acpi-lid.sh"
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

  # Called when the AC power is connected or disconnected.
  acEventHandler = pkgs.writeScript "ac-power.sh"
    ''
      #! ${pkgs.bash}/bin/sh

      if grep -q "state:.*on-line" /proc/acpi/ac_adapter/AC/state; then
         echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      elif grep -q "state:.*off-line" /proc/acpi/ac_adapter/AC/state; then
         echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      fi
    '';

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
