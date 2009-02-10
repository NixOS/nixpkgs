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
    '';

  # Called when the power button is pressed.
  powerEventHandler = pkgs.writeScript "acpi-power.sh"
    ''
      #! ${pkgs.bash}/bin/sh
      # Suspend to RAM.
      #echo mem > /sys/power/state
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
