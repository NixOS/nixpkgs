{bash}:

{
  name = "sys-halt";
  
  job = "
start on reboot
start on halt
start on system-halt
start on power-off

script
    exec < /dev/tty1 > /dev/tty1 2>&1
    echo \"\"
    echo \"<<< SYSTEM SHUTDOWN >>>\"
    echo \"\"

    # Right now all events above power off the system.
    exec halt -f -p
end script
  ";
  
}
