{ pkgs, ... }:

{

  machine = 
    { config, pkgs, ... }:

    { require = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.auto.enable = true;
      services.xserver.displayManager.auto.user = "alice";
      
      services.xserver.desktopManager.xfce.enable = true;
    };

  testScript =
    ''
      $machine->waitForWindow(qr/Tips/);
      $machine->sleep(10);
      $machine->succeed("su - alice -c 'DISPLAY=:0.0 Terminal &'");
      $machine->waitForWindow(qr/Terminal/);
      $machine->sleep(10);
      $machine->screenshot("screen");
    '';
  
}
