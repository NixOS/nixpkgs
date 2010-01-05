{ pkgs, ... }:

{

  machine = 
    { config, pkgs, ... }:

    { services.xserver.enable = true;
      services.xserver.displayManager.slim.enable = false;
      services.xserver.displayManager.auto.enable = true;

      services.xserver.windowManager.default = "icewm";
      services.xserver.windowManager.icewm.enable = true;

      services.xserver.desktopManager.default = "none";
            
      environment.systemPackages = [ pkgs.firefox ];
    };

  testScript =
    ''
      $machine->waitForFile("/tmp/.X11-unix/X0");

      sleep 10;

      $machine->execute("DISPLAY=:0.0 HOME=/root firefox file://${pkgs.valgrind}/share/doc/valgrind/html/index.html &");

      sleep 30;

      $machine->screenshot("screen");
    '';
  
}
