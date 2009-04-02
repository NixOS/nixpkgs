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
          
      start script
        # !!! quick hack: wait until dbus has started
        sleep 3
      end script
      
      respawn ${pkgs.ConsoleKit}/sbin/console-kit-daemon
    '';
}
