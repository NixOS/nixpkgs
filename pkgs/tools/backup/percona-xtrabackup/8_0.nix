{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "8.0.13";
  sha256 = "0cj0fnjimv22ykfl0yk6w29wcjvqp8y8j2g1c6gcml65qazrswyr";

  extraPatches = [
    ./abi-check.patch
  ];

  extraPostInstall = ''
    rm -r "$out"/docs
  '';
})
