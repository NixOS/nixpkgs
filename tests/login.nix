{ pkgs, ... }:

{

  machine = { config, pkgs, ... }: { };

  testScript =
    ''
      $machine->mustSucceed("useradd -m alice");
      $machine->mustSucceed("echo foobar | passwd --stdin alice");

      # Log in as alice on a virtual console.      
      $machine->waitForJob("tty1");
      $machine->sendChars("alice\n");
      $machine->waitUntilSucceeds("pgrep login");
      $machine->execute("sleep 2"); # urgh: wait for `Password:'
      $machine->sendChars("foobar\n");
      $machine->waitUntilSucceeds("pgrep -u alice bash");
      $machine->sendChars("touch done\n");
      $machine->waitForFile("/home/alice/done");
      
      # Check whether switching VTs works.
      $machine->sendKeys("alt-f10");
      $machine->waitUntilSucceeds("[ \$(fgconsole) = 10 ]");
      $machine->execute("sleep 2"); # allow fbcondecor to catch up (not important)
      $machine->screenshot("syslog");

      # Check whether ConsoleKit/udev gives and removes device
      # ownership as needed.
      $machine->mustSucceed("chvt 1");
      $machine->execute("sleep 1"); # urgh
      $machine->mustSucceed("getfacl /dev/snd/timer | grep -q alice");
      $machine->mustSucceed("chvt 2");
      $machine->execute("sleep 1"); # urgh
      $machine->mustFail("getfacl /dev/snd/timer | grep -q alice");

      # Log out.
      $machine->mustSucceed("chvt 1");
      $machine->sendChars("exit\n");
      $machine->waitUntilFails("pgrep -u alice bash");
      $machine->screenshot("mingetty");
      
      # Check whether ctrl-alt-delete works.
      $machine->sendKeys("ctrl-alt-delete");
      $machine->waitForShutdown;
    '';
  
}
