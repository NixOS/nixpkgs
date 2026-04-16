{
  mkKdeDerivation,
  lib,
  replaceVars,
  smartmontools,
}:
mkKdeDerivation {
  pname = "plasma-disks";

  patches = [
    (replaceVars ./smartctl-path.patch {
      smartctl = smartmontools.exe;
    })
  ];
}
