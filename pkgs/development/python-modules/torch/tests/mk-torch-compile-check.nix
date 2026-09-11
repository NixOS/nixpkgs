{
  cudaPackages,
  feature ? null,
  lib,
  libraries,
  name ? if feature == null then "torch-compile-cpu" else "torch-compile-${feature}",
  stdenv,
  writableTmpDirAsHomeHook,
}:
let
  deviceStr = if feature == null then "" else '', device="cuda"'';
in
cudaPackages.writeGpuTestPython
  {
    inherit name feature libraries;

    # This could be accomplished with propagatedBuildInputs instead of introducing
    gpuCheckArgs.nativeBuildInputs = [
      # torch._inductor.exc.InductorError: PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
      writableTmpDirAsHomeHook
    ];
    makeWrapperArgs = [
      "--suffix"
      "PATH"
      ":"
      "${lib.getBin stdenv.cc}/bin"
    ]
    # Inductor compiles its generated C++ with `-g1`, which makes clang spawn `dsymutil`.
    # The bintools wrapper does not re-export it, so take it from the unwrapped cctools.
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--suffix"
      "PATH"
      ":"
      "${lib.getBin stdenv.cc.bintools.bintools}/bin"
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
