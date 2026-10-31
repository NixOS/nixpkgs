{
  cudaPackages,
  feature ? null,
  lib,
  libraries,
  name ? if feature == null then "torch-aot-inductor-cpu" else "torch-aot-inductor-${feature}",
  stdenv,
  writableTmpDirAsHomeHook,
}:
let
  device = if feature == null then "cpu" else "cuda";
in
cudaPackages.writeGpuTestPython
  {
    inherit name feature libraries;

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
    import os
    import tempfile

    import torch


    class Model(torch.nn.Module):
        def __init__(self):
            super().__init__()
            self.linear = torch.nn.Linear(16, 16)

        def forward(self, x):
            return torch.relu(self.linear(x))


    model = Model().to("${device}").eval()
    x = torch.randn(8, 16, device="${device}")
    exported = torch.export.export(model, (x,))

    # Compile ahead of time into a package with a shared library, then dlopen it.
    package_path = torch._inductor.aoti_compile_and_package(
        exported, package_path=os.path.join(tempfile.mkdtemp(), "model.pt2")
    )
    compiled = torch._inductor.aoti_load_package(package_path)
    torch.testing.assert_close(compiled(x), model(x))
    print("AOTInductor package matches eager")
  ''
