{ pkgs, ... }:

{

  machine = { config, pkgs, ... }: { };

  testScript =
    ''
      subtest "create user", sub {
          $machine->succeed("useradd -m alice");
          $machine->succeed("(echo foobar; echo foobar) | passwd alice");
      };

      # Log in as alice on a virtual console.
      subtest "virtual console login", sub {
          $machine->waitForJob("tty1");
          $machine->sendChars("alice\n");
          $machine->waitUntilSucceeds("pgrep login");
          $machine->sleep(2); # urgh: wait for `Password:'
          $machine->sendChars("foobar\n");
          $machine->waitUntilSucceeds("pgrep -u alice bash");
          $machine->sendChars("touch done\n");
          $machine->waitForFile("/home/alice/done");
      };
      
      # Check whether switching VTs works.
      subtest "virtual console switching", sub {
          $machine->sendKeys("alt-f10");
          $machine->waitUntilSucceeds("[ \$(fgconsole) = 10 ]");
          $machine->sleep(2); # allow fbcondecor to catch up (not important)
          $machine->screenshot("syslog");
      };

      # Check whether ConsoleKit/udev gives and removes device
      # ownership as needed.
      subtest "device permissions", sub {
          $machine->succeed("chvt 1");
          $machine->sleep(1); # urgh
          $machine->succeed("getfacl /dev/snd/timer | grep -q alice");
          $machine->succeed("chvt 2");
          $machine->sleep(1); # urgh
          $machine->fail("getfacl /dev/snd/timer | grep -q alice");
      };

      # Log out.
      subtest "virtual console logout", sub {
          $machine->succeed("chvt 1");
          $machine->sendChars("exit\n");
          $machine->waitUntilFails("pgrep -u alice bash");
          $machine->screenshot("mingetty");
      };
      
      # Check whether ctrl-alt-delete works.
      subtest "ctrl-alt-delete", sub {
          $machine->sendKeys("ctrl-alt-delete");
          $machine->waitForShutdown;
      };
    '';
  
}
