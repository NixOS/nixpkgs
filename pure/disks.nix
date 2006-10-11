{

  /* Old school. */

  volume1 = {
    mountPoint = "/";
    filesystem = "ext3";
    location = {
      device = "/dev/hda1";
    };
    creationParams = {
      disk = "/dev/hda";
      partition = 1;
      startCylinder = 1;
      endCylinder = 1000;
    };
  };
  
  volume2 = {
    filesystem = "swap";
    location = {
      device = "/dev/hda2";
    };
    creationParams = {
      disk = "/dev/hda";
      startCylinder = 1001;
      endCylinder = 1100;
    };
  };


  /* With partition labels; don't care which device holds the file
    system. */

  volume1 = {
    mountPoint = "/";
    filesystem = "auto";
    location = {
      label = "ROOT_DISK";
    };
    # Only relevant when creating.
    creationParams = {
      disk = "/dev/hda";
      partition = 1;
      startCylinder = 1;
      endCylinder = 1000;
      filesystem = "ext3";
    };
  };


  /* LVM. */

  volume1 = {
    mountPoint = "/data";
    filesystem = "auto";
    location = {
      lvmVolumeGroup = "system";
      lvmVolumeName = "big-volume"; # -> /dev/mapper/system-big-volume
    };
  };

  lvmConfig = {
    devices = [
      ...
    ];
    groups = [
      { name = "system";
        volumes = [
          { name = "big-volume";
            size = 1048576; # -> 1 GiB
          }
          { name = "blah";
            size = 1048576; # -> 1 GiB
          }
        ];
        # When realising this configuration, only delete explicitly
        # listed volumes for safety.
        canDelete = ["foobar"];
      };
    ];
  };
  
}
