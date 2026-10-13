{
  lib,
  stdenv,
  callPackage,
  torchvision,
  torchcodec,
  torchaudio,

  rocmSupport,
  cudaSupport,
}:

let
  cudaOnly = {
    # To perform the runtime check use either
    # `nix run .#python3Packages.torch.tests.tester-cudaAvailable` (outside the sandbox), or
    # `nix build .#python3Packages.torch.tests.tester-cudaAvailable.gpuCheck` (in a relaxed sandbox)
    tester-cudaAvailable = callPackage ./mk-runtime-check.nix {
      feature = "cuda";
      versionAttr = "cuda";
      libraries = ps: [ ps.torchWithCuda ];
    };

    tester-compileCuda = callPackage ./mk-torch-compile-check.nix {
      feature = "cuda";
      libraries = ps: [ ps.torchWithCuda ];
    };
  };

  rocmOnly = {
    tester-rocmAvailable = callPackage ./mk-runtime-check.nix {
      feature = "rocm";
      versionAttr = "hip";
      libraries = ps: [ ps.torchWithRocm ];
    };
    tester-compileRocm = callPackage ./mk-torch-compile-check.nix {
      feature = "rocm";
      libraries = ps: [ ps.torchWithRocm ];
    };
  };
in
let
  tester-compileCpu = callPackage ./mk-torch-compile-check.nix {
    feature = null;
    libraries = ps: [ ps.torch ];
  };
in
{
  inherit tester-compileCpu;
  compileCpu = tester-compileCpu.gpuCheck;

  mnist-example = callPackage ./mnist-example { };

  # Core packages from the torch ecosystem
  inherit torchvision torchaudio torchcodec;
}
// lib.optionalAttrs cudaSupport cudaOnly
// lib.optionalAttrs rocmSupport rocmOnly
