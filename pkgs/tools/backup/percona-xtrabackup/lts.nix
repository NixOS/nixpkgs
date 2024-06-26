{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "8.0.35-30";
  hash = "sha256-yagqBKU057Gk5pEyT2R3c5DtxNG/+TSPenFgbxUiHPo=";

  # includes https://github.com/Percona-Lab/libkmip.git
  fetchSubmodules = true;

  extraPatches = [
    ./abi-check.patch
  ];

  extraPostInstall = ''
    rm -r "$out"/docs
  '';
})
