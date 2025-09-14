{
  lib,
  recurseIntoAttrs,

  cudaPackages,

  cudaPackages_12_6,
  cudaPackages_12_8,
  cudaPackages_12_9,
  cudaPackages_12,
}@args:

let
  isTest =
    name: package:
    builtins.elem (package.pname or null) [
      "cuda-library-samples"
      "saxpy"
    ];
in
(lib.trivial.pipe args [
  (lib.filterAttrs (name: _: lib.hasPrefix "cudaPackages" name))
  (lib.mapAttrs (
    _: ps:
    lib.pipe ps [
      (lib.filterAttrs isTest)
      recurseIntoAttrs
    ]
  ))
  recurseIntoAttrs
])
