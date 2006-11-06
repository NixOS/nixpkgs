{ genericSubstituter, shell, coreutils
, utillinux, kernel, sysklogd, mingetty
, path ? []
}:

genericSubstituter {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit shell kernel sysklogd mingetty;
  path = [
    coreutils
    utillinux
  ];
  extraPath = path;
  makeDevices = ./make-devices.sh;
}
