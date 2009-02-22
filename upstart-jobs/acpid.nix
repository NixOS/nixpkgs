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
    '';

  # Called when the power button is pressed.
  powerEventHandler = pkgs.writeScript "acpi-power.sh"
    ''
      #! ${pkgs.bash}/bin/sh
      # Suspend to RAM.
      #echo mem > /sys/power/state
      exit 0
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

      exit 0
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
