{ genericSubstituter, shell, coreutils, findutils
, utillinux, kernel, sysklogd, mingetty, udev
, module_init_tools, nettools, dhcp
, path ? []
}:

genericSubstituter {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit shell kernel sysklogd mingetty;
  path = [
    coreutils
    findutils
    utillinux
    udev
    module_init_tools
    nettools
    dhcp
  ];
  extraPath = path;
  makeDevices = ./make-devices.sh;
}
