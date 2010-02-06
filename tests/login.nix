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
      $machine->sendChars("exit\n");
      $machine->waitUntilFails("pgrep -u alice bash");
      $machine->screenshot("mingetty");
      
      # Check whether switching VTs works.
      $machine->sendKeys("alt-f10");
      $machine->waitUntilSucceeds("[ \$(fgconsole) = 10 ]");
      $machine->execute("sleep 2"); # allow fbcondecor to catch up (not important)
      $machine->screenshot("syslog");

      # Check whether ctrl-alt-delete works.
      $machine->sendKeys("alt-f1");
      $machine->sendKeys("ctrl-alt-delete");
      $machine->waitForShutdown;
    '';
  
}
