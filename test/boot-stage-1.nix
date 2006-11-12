# This Nix expression builds the script that performs the first stage
# of booting the system: it loads the modules necessary to mount the
# root file system, then calls /init in the root file system to start
# the second boot stage.  The closure of the result of this expression
# is supposed to be put into an initial RAM disk (initrd).

{ genericSubstituter, shell, staticTools
, module_init_tools, extraUtils, modules

, # Whether to find root device automatically using its label.
  autoDetectRootDevice
  
, # If not scanning, the root must be specified explicitly.
  rootDevice

  # If scanning, we need a disk label.
, rootLabel
}:

assert !autoDetectRootDevice -> rootDevice != "";
assert autoDetectRootDevice -> rootLabel != "";

genericSubstituter {
  src = ./boot-stage-1-init.sh;
  isExecutable = true;
  inherit shell modules;
  inherit autoDetectRootDevice rootDevice rootLabel;
  path = [
    staticTools
    module_init_tools
    extraUtils
  ];
  makeDevices = ./make-devices.sh;
}
