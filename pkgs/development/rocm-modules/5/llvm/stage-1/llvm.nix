{ stdenv
, callPackage
, rocmUpdateScript
}:

callPackage ../base.nix {
  inherit rocmUpdateScript;
  requiredSystemFeatures = [ "big-parallel" ];
  isBroken = stdenv.isAarch64; # https://github.com/RadeonOpenCompute/ROCm/issues/1831#issuecomment-1278205344
}
