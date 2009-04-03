args: with args;

let

cfg = config.services.consolekit;

in
{
    name = "consolekit";
        
    job = ''
      description "Console Kit Service"

      start on dbus
      stop on shutdown  
          
      respawn ${pkgs.ConsoleKit}/sbin/console-kit-daemon
    '';
}
