{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "8.0.34-29";
  hash = "sha256-dO5ciIIAnKj2t+fYhrtnY7MvBThoA+SymBzN8H07giM=";

  # includes https://github.com/Percona-Lab/libkmip.git
  fetchSubmodules = true;

  extraPatches = [
    ./abi-check.patch
  ];

  extraPostInstall = ''
    rm -r "$out"/docs
  '';
})
