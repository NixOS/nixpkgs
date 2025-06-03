{
  cudaPackages,
  feature ? null,
  lib,
  libraries,
  name ? if feature == null then "torch-compile-cpu" else "torch-compile-${feature}",
  stdenv,
}:
let
  deviceStr = if feature == null then "" else '', device="cuda"'';
in
cudaPackages.writeGpuTestPython
  {
    inherit name feature libraries;
    makeWrapperArgs = [
      "--suffix"
      "PATH"
      ":"
      "${lib.getBin stdenv.cc}/bin"
    ];
  }
  ''
    import torch


    @torch.compile
    def opt_foo2(x, y):
        a = torch.sin(x)
        b = torch.cos(y)
        return a + b


    print(
      opt_foo2(
        torch.randn(10, 10${deviceStr}),
        torch.randn(10, 10${deviceStr})))
  ''
