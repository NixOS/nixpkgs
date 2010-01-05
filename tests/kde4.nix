{ pkgs, ... }:

{

  machine = 
    { config, pkgs, ... }:

    { services.xserver.enable = true;

      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.httpd.documentRoot = "${pkgs.valgrind}/share/doc/valgrind/html";

      services.xserver.displayManager.slim.enable = false;
      services.xserver.displayManager.kdm.enable = true;
      services.xserver.displayManager.kdm.extraConfig =
        ''
          [X-:0-Core]
          AutoLoginEnable=true
          AutoLoginUser=alice
          AutoLoginPass=foobar
        '';

      services.xserver.desktopManager.default = "kde4";
      services.xserver.desktopManager.kde4.enable = true;

      users.extraUsers = pkgs.lib.singleton
        { name = "alice";
          description = "Alice Foobar";
          home = "/home/alice";
          createHome = true;
          useDefaultShell = true;
          password = "foobar";
        };
    };

  testScript =
    ''
      $machine->waitForWindow(qr/plasma-desktop/);

      $machine->execute("su - alice -c 'DISPLAY=:0.0 kwrite /var/log/messages &'");
      $machine->execute("su - alice -c 'DISPLAY=:0.0 konqueror http://localhost/ &'");

      $machine->waitForWindow(qr/messages.*KWrite/);
      $machine->waitForWindow(qr/Valgrind.*Konqueror/);

      sleep 5;
      
      $machine->screenshot("screen");
    '';
  
}
