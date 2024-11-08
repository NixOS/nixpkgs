{ callPackage }:

rec {
  # To perform the runtime check use either
  # `nix run .#python3Packages.torch.tests.tester-cudaAvailable` (outside the sandbox), or
  # `nix build .#python3Packages.torch.tests.tester-cudaAvailable.gpuCheck` (in a relaxed sandbox)
  tester-cudaAvailable = callPackage ./mk-runtime-check.nix {
    feature = "cuda";
    versionAttr = "cuda";
    libraries = ps: [ ps.torchWithCuda ];
  };
  tester-rocmAvailable = callPackage ./mk-runtime-check.nix {
    feature = "rocm";
    versionAttr = "hip";
    libraries = ps: [ ps.torchWithRocm ];
  };

  compileCpu = tester-compileCpu.gpuCheck;
  tester-compileCpu = callPackage ./mk-torch-compile-check.nix {
    feature = null;
    libraries = ps: [ ps.torch ];
  };
  tester-compileCuda = callPackage ./mk-torch-compile-check.nix {
    feature = "cuda";
    libraries = ps: [ ps.torchWithCuda ];
  };
  tester-compileRocm = callPackage ./mk-torch-compile-check.nix {
    feature = "rocm";
    libraries = ps: [ ps.torchWithRocm ];
  };
}
