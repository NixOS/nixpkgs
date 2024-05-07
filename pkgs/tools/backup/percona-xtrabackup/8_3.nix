{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "8.3.0-1";
  hash = "sha256-qZM2AFhpwrN0BR+DdozYn7s2I+c1tWpD5QvppTEfGEY=";

  # includes https://github.com/Percona-Lab/libkmip.git
  fetchSubmodules = true;

  extraPatches = [
  ];

  extraPostInstall = ''
  '';
})
