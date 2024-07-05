{
  lib,
  torchWithCuda,
  torchWithRocm,
  callPackage,
}:

let
  accelAvailable =
    {
      feature,
      versionAttr,
      torch,
      cudaPackages,
    }:
    cudaPackages.writeGpuTestPython
      {
        inherit feature;
        libraries = [ torch ];
        name = "${feature}Available";
      }
      ''
        import torch
        message = f"{torch.cuda.is_available()=} and {torch.version.${versionAttr}=}"
        assert torch.cuda.is_available() and torch.version.${versionAttr}, message
        print(message)
      '';
in
{
  tester-cudaAvailable = callPackage accelAvailable {
    feature = "cuda";
    versionAttr = "cuda";
    torch = torchWithCuda;
  };
  tester-rocmAvailable = callPackage accelAvailable {
    feature = "rocm";
    versionAttr = "hip";
    torch = torchWithRocm;
  };
}
