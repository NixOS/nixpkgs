{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "8.0.29-22";
  sha256 = "sha256-dGpfU+IesAyr2s1AEjfYggOEkMGQ9JdEesu5PtJHNXA=";

  # includes https://github.com/Percona-Lab/libkmip.git
  fetchSubmodules = true;

  extraPatches = [
    ./abi-check.patch
  ];

  extraPostInstall = ''
    rm -r "$out"/docs
  '';
})
