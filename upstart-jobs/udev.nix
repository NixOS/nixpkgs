{ stdenv, writeText, substituteAll, cleanSource, udev, procps, firmwareDirs, modprobe
, extraUdevPkgs ? []
, config
}:

let

  cfg = config.services.udev;

  firmwareLoader = substituteAll {
    src = ./udev-firmware-loader.sh;
    path = "${stdenv.coreutils}/bin";
    isExecutable = true;
    inherit firmwareDirs;
  };
    
  nixRules = writeText "90-nix.rules" ''
  
    # Miscellaneous devices.
    KERNEL=="sonypi",               MODE="0666"
    KERNEL=="kvm",                  MODE="0666"
    KERNEL=="kqemu",                NAME="%k", MODE="0666"

    # Create symlinks for CD/DVD devices.
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_CDROM}=="?*", SYMLINK+="cdrom cdrom-%k"
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_CDROM_CD_RW}=="?*", SYMLINK+="cdrw cdrw-%k"
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_CDROM_DVD}=="?*", SYMLINK+="dvd dvd-%k"
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_CDROM_DVD_RW}=="?*", SYMLINK+="dvdrw dvdrw-%k"
    
    # ALSA sound devices.
    KERNEL=="controlC[0-9]*",       NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="hwC[D0-9]*",           NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="pcmC[D0-9cp]*",        NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="midiC[D0-9]*",         NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="timer",                NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="seq",                  NAME="snd/%k", MODE="${cfg.sndMode}"

    # Firmware loading.
    SUBSYSTEM=="firmware",          ACTION=="add", RUN+="${firmwareLoader}"
    
  '';
  
  # Perform substitutions in all udev rules files.
  udevRules = stdenv.mkDerivation {
    name = "udev-rules";
    #src = cleanSource ./udev-rules;
    buildCommand = ''
      ensureDir $out
      ln -s ${nixRules} $out/${nixRules.name}
      shopt -s nullglob
      cp ${udev}/*/udev/rules.d/*.rules $out/
      
      ${if config.boot.hardwareScan then
        ''
          substituteInPlace $out/80-drivers.rules \
            --replace /sbin/modprobe ${modprobe}/sbin/modprobe
        ''
        else
        ''
          rm $out/80-drivers.rules
        ''
      }
      for i in ${toString extraUdevPkgs}; do
        for j in $i/*/udev/rules.d/*; do
          ln -s $j $out/$(basename $j)
        done
      done
    ''; # */
  };

  # The udev configuration file.
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

        # Do the loading of additional stage 2 kernel modules.
        # Maybe this isn't the best place...
        for i in ${toString config.boot.kernelModules}; do
            echo "Loading kernel module $i..."
            ${modprobe}/sbin/modprobe $i || true
        done

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

  passthru = {inherit udevRules;};
}
