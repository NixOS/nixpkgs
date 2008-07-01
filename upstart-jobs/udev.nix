{ stdenv, writeText, substituteAll, cleanSource, udev, procps, firmwareDirs
, extraUdevPkgs ? []
, sndMode ? "0600"
}:

let

  # Perform substitutions in all udev rules files.
  udevRules = stdenv.mkDerivation {
    name = "udev-rules";
    src = cleanSource ./udev-rules;
    firmwareLoader = substituteAll {
      src = ./udev-firmware-loader.sh;
      path = "${stdenv.coreutils}/bin";
      isExecutable = true;
      inherit firmwareDirs;
    };
    inherit sndMode;
    buildCommand = "
      buildCommand= # urgh
      ensureDir $out
      for i in $src/*; do
        substituteAll $i $out/$(basename $i)
      done
      shopt -s nullglob
      for i in ${toString extraUdevPkgs}; do
        for j in $i/etc/udev/rules.d/*; do
          ln -s $j $out/$(basename $j)
        done
      done
    ";
  };

  # The udev configuration file
  conf = writeText "udev.conf" ''
    udev_rules="${udevRules}"
    #udev_log="debug"
  '';

  # Dummy file indicating whether we've run udevtrigger/udevsettle.
  # Since that *recreates* all device nodes with default permissions,
  # it's not nice to do that when a user is logged in (it messes up
  # the permissions set by pam_devperm).
  # !!! Actually, this makes the udev configuration less declarative;
  # changes may not take effect until the user reboots.  We should
  # find a better way to preserve the permissions of logged-in users.
  devicesCreated = "/var/run/devices-created";

in

{
  name = "udev";
  
  job = ''
    start on startup
    stop on shutdown

    env UDEV_CONFIG_FILE=${conf}

    start script
	echo "" > /proc/sys/kernel/hotplug

	# Get rid of possible old udev processes.
	${procps}/bin/pkill -u root "^udevd$" || true

	# Start udev.
	${udev}/sbin/udevd --daemon

	# Let udev create device nodes for all modules that have already
	# been loaded into the kernel (or for which support is built into
	# the kernel).
	if ! test -e ${devicesCreated}; then
	    ${udev}/sbin/udevadm trigger
	    ${udev}/sbin/udevadm settle # wait for udev to finish
	    touch ${devicesCreated}
	fi

	# Kill udev, let Upstart restart and monitor it.  (This is nasty,
	# but we have to run `udevadm trigger' first.  Maybe we can use
	# Upstart's `binary' keyword, but it isn't implemented yet.)
	if ! ${procps}/bin/pkill -u root "^udevd$"; then
	    echo "couldn't stop udevd"
	fi

	while ${procps}/bin/pgrep -u root "^udevd$"; do
	    sleep 1
	done

	initctl emit new-devices
    end script

    respawn ${udev}/sbin/udevd
  '';

}
