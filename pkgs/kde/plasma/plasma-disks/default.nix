{
  mkKdeDerivation,
  lib,
  substituteAll,
  smartmontools,
}:
mkKdeDerivation {
  pname = "plasma-disks";

  patches = [
    (substituteAll {
      smartctl = lib.getExe smartmontools;
      src = ./smartctl-path.patch;
    })
  ];
}
