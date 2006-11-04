{ genericSubstituter, shell, coreutils
, utillinux
}:

genericSubstituter {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit shell;
  path = [
    coreutils
    utillinux
  ];
  makeDevices = ./make-devices.sh;
}
