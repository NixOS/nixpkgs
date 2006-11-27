{ genericSubstituter, shell, coreutils, findutils
, utillinux, kernel, udev, upstart
, path ? []

, # Whether the root device is root only.  If so, we'll mount a
  # ramdisk on /etc, /var and so on.
  readOnlyRoot

, # The Upstart job configuration.
  upstartJobs

, hostName
}:

genericSubstituter {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit shell kernel upstart readOnlyRoot upstartJobs hostName;
  path = [
    coreutils
    findutils
    utillinux
    udev
    upstart
  ];
  extraPath = path;
}
