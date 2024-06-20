{
  lib,
  callPackage,
  torchWithCuda,
  torchWithRocm,
}:

let
  accelAvailable =
    {
      feature,
      versionAttr,
      torch,
      runCommandNoCC,
      writers,
    }:
    let
      name = "${torch.name}-${feature}-check";
      unwrapped = writers.writePython3Bin "${name}-unwrapped" { libraries = [ torch ]; } ''
        import torch
        message = f"{torch.cuda.is_available()=} and {torch.version.${versionAttr}=}"
        assert torch.cuda.is_available() and torch.version.${versionAttr}, message
        print(message)
      '';
    in
    runCommandNoCC name
      {
        nativeBuildInputs = [ unwrapped ];
        requiredSystemFeatures = [ feature ];
        passthru = {
          inherit unwrapped;
        };
      }
      ''
        ${name}-unwrapped
        touch $out
      '';
in
{
  cudaAvailable = callPackage accelAvailable {
    feature = "cuda";
    versionAttr = "cuda";
    torch = torchWithCuda;
  };
  rocmAvailable = callPackage accelAvailable {
    feature = "rocm";
    versionAttr = "hip";
    torch = torchWithRocm;
  };
}
