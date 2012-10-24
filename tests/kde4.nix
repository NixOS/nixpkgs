{ pkgs, ... }:

{

  machine =
    { config, pkgs, ... }:

    { require = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.httpd.documentRoot = "${pkgs.valgrind}/share/doc/valgrind/html";

      services.xserver.displayManager.kdm.enable = true;
      services.xserver.displayManager.kdm.extraConfig =
        ''
          [X-:0-Core]
          AutoLoginEnable=true
          AutoLoginUser=alice
          AutoLoginPass=foobar
        '';

      services.xserver.desktopManager.kde4.enable = true;
    };

  testScript =
    ''
      $machine->waitUntilSucceeds("pgrep plasma-desktop");
      $machine->waitForWindow(qr/plasma-desktop/);

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

      $machine->execute("su - alice -c 'DISPLAY=:0.0 kwrite /var/log/messages &'");
      $machine->execute("su - alice -c 'DISPLAY=:0.0 konqueror http://localhost/ &'");

      $machine->waitForWindow(qr/messages.*KWrite/);
      $machine->waitForWindow(qr/Valgrind.*Konqueror/);

      $machine->sleep(5);

      $machine->screenshot("screen");
    '';

}
