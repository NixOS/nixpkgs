{
  callPackage,
  torchWithCuda,
  torchWithRocm,
}:

{
  # To perform the runtime check use either
  # `nix run .#python3Packages.torch.tests.tester-cudaAvailable` (outside the sandbox), or
  # `nix build .#python3Packages.torch.tests.tester-cudaAvailable.gpuCheck` (in a relaxed sandbox)
  tester-cudaAvailable = callPackage ./mk-runtime-check.nix {
    feature = "cuda";
    versionAttr = "cuda";
    torch = torchWithCuda;
  };
  tester-rocmAvailable = callPackage ./mk-runtime-check.nix {
    feature = "rocm";
    versionAttr = "hip";
    torch = torchWithRocm;
  };
}
