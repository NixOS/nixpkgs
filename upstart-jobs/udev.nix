{udev, procps}:

{
  name = "udev";
  
  job = "
start on startup
stop on shutdown

start script
    echo '' > /proc/sys/kernel/hotplug

    # Start udev.
    ${udev}/sbin/udevd --daemon

    # Let udev create device nodes for all modules that have already
    # been loaded into the kernel (or for which support is built into
    # the kernel).
    ${udev}/sbin/udevtrigger
    ${udev}/sbin/udevsettle # wait for udev to finish

    # Kill udev, let Upstart restart and monitor it.  (This is nasty,
    # but we have to run udevtrigger first.  Maybe we can use
    # Upstart's `binary' keyword, but it isn't implemented yet.)
    ${procps}/bin/pkill -u root '^udevd$'
end script

respawn ${udev}/sbin/udevd
  ";

}
