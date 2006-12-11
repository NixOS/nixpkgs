{bash, event, utillinux}:

assert event == "reboot"
    || event == "halt"
    || event == "system-halt"
    || event == "power-off";

{
  name = "sys-" + event;
  
  job = "
start on ${event}

script
    exec < /dev/tty1 > /dev/tty1 2>&1
    echo \"\"
    echo \"<<< SYSTEM SHUTDOWN >>>\"
    echo \"\"

    export PATH=${utillinux}/bin:$PATH

    # Do an initial sync just in case.
    sync || true

    # Unmount file systems.
    umount -n -a || true

    # Remount / read-only
    mount -n -o remount,ro /dontcare / || true

    # Final sync.
    sync || true

    # Right now all events above power off the system.
    if test ${event} = reboot; then
        exec reboot -f
    else
        exec halt -f -p
    fi
end script
  ";
  
}
