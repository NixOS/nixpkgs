{ stdenv
, lib
, fetchpatch
, callPackage
, rocmUpdateScript
}:

callPackage ../base.nix {
  inherit stdenv rocmUpdateScript;
  requiredSystemFeatures = [ "big-parallel" ];
  isBroken = stdenv.isAarch64; # https://github.com/ROCm/ROCm/issues/1831#issuecomment-1278205344
  buildTests = false;
  # extraPatches = [
  #   (fetchpatch {
  #     name = "llvm-support-compressing-device-binary.patch";
  #     url = "https://github.com/GZGavinZhao/llvm-project/commit/fae9d73436c8fb71fdd16a078f485c9cbe99be27.patch";
  #     hash = "sha256-wISQTE73cjtWOJ46idN6mn06jm2ML4B3fJJWmfzi0as=";
  #   })
  # ];
}
