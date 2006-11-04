{ genericSubstituter, shell, coreutils
, utillinux, kernel, path ? []
}:

genericSubstituter {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit shell kernel;
  path = [
    coreutils
    utillinux
  ];
  extraPath = path;
  makeDevices = ./make-devices.sh;
}
