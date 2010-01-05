{ pkgs, ... }:

{

  machine = 
    { config, pkgs, ... }:

    { services.xserver.enable = true;
      environment.systemPackages = [ pkgs.icewm pkgs.firefox ];
    };

  testScript =
    ''
      $machine->waitForFile("/tmp/.X11-unix/X0");

      sleep 10;

      $machine->execute("DISPLAY=:0.0 icewm &");

      sleep 10;
      
      $machine->execute("DISPLAY=:0.0 HOME=/root firefox file://${pkgs.valgrind}/share/doc/valgrind/html/index.html &");

      sleep 30;

      $machine->screenshot("screen");
    '';
  
}
