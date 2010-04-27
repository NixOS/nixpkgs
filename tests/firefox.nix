{ pkgs, ... }:

{

  machine = 
    { config, pkgs, ... }:

    { require = [ ./common/x11.nix ];
      environment.systemPackages = [ pkgs.firefox ];
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->execute("firefox file://${pkgs.valgrind}/share/doc/valgrind/html/index.html &");
      $machine->waitForWindow(/Valgrind.*Shiretoko/);
      sleep 40; # wait until Firefox has finished loading the page
      $machine->screenshot("screen");
    '';
  
}
