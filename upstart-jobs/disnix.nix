args: with args;

let

cfg = config.services.disnix;

in
{
    name = "disnix";
        
    job = ''
      description "Disnix server"

      start on dbus
      stop on shutdown  
          
      start script
        # !!! quick hack: wait until dbus has started
        sleep 3
      end script
      
      respawn ${pkgs.bash}/bin/sh -c 'export PATH=/var/run/current-system/sw/bin:$PATH; export HOME=/root; ${pkgs.disnix}/bin/disnix-service'
    '';
}
