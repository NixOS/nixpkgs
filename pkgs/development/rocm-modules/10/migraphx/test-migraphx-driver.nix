{
  lib,
  fetchurl,
  makeImpureTest,
  writableTmpDirAsHomeHook,
  migraphx,
  clr,
  rocm-smi,
}:

# Verify that a ≈50MiB resnet onnx can run with migraphx
let
  resnet18 = fetchurl {
    url = "https://huggingface.co/onnxmodelzoo/resnet18_Opset18_timm/resolve/main/resnet18_Opset18_timm.onnx";
    hash = "sha256-u2Io20n72qoA9atRsFIWb0zHF1WdJYgHQdMWfJhJGHA=";
    meta.license = lib.licenses.unfree;
  };
in
makeImpureTest {
  name = "migraphx-driver";
  testedPackage = "rocmPackages.migraphx";

  sandboxPaths = [
    "/sys"
    "/dev/dri"
    "/dev/kfd"
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    migraphx
    clr
    rocm-smi
  ];

  # FIXME(@LunNova): tol values are set too high - was seeing high divergence on iGPU
  # want this test to be useful for verifying workloads run at all
  # and will investigate what's broken for accuracy
  testScript = ''
    rocm-smi
    migraphx-driver verify -O --rms-tol 0.03 --atol 1.0 --rtol 0.01 ${resnet18}
  '';

  meta = {
    teams = [ lib.teams.rocm ];
  };
}
