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

    # Do an initial sync just in case.
    sync || true

    # Unmount file systems.
    umount -n -a || true

    # Remount / read-only
    mount -n -o remount,ro /dontcare / || true

    # Final sync.
    sync || true

    # Right now all events above power off the system.
    exec halt -f
end script
  ";
  
}
