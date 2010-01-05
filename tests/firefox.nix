{ pkgs, ... }:

{

  machine = 
    { config, pkgs, ... }:

    { require = [ ./common/x11.nix ];
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
