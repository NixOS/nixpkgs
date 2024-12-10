{
  stdenv,
  callPackage,
  rocmUpdateScript,
}:

callPackage ../base.nix {
  inherit stdenv rocmUpdateScript;
  requiredSystemFeatures = [ "big-parallel" ];
  isBroken = stdenv.isAarch64; # https://github.com/ROCm/ROCm/issues/1831#issuecomment-1278205344
}
