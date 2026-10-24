{
  lib,
  buildPythonPackage,

  # nativeBuildInputs
  pyprojectVersionPatchHook,

  # build-system
  setuptools,

  # dependencies
  numpy,
  torch,
  triton,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  triton-kernels,
}:

buildPythonPackage (finalAttrs: {
  pname = "triton-kernels";
  # triton_kernels lives in Triton's repository and is released with it, while its own version has been "1.0.0"
  # since its introduction; use Triton's version to tell the releases apart.
  inherit (triton) version;
  pyproject = true;
  __structuredAttrs = true;

  inherit (triton) src;

  sourceRoot = "${finalAttrs.src.name}/python/triton_kernels";

  # Make the wheel's version match `version`, which the metadata check requires.
  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  # torch and triton are imported throughout but not declared, as the package expects to be installed alongside the
  # Triton it comes from.
  dependencies = [
    numpy
    torch
    triton
  ];

  # Declared, but only the tests use it.
  pythonRemoveDeps = [ "pytest" ];

  pythonImportsCheck = [
    "triton_kernels"
    "triton_kernels.matmul"
    "triton_kernels.reduce"
    "triton_kernels.swiglu"
    "triton_kernels.tensor"
    "triton_kernels.topk"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # Triton writes its kernel cache under $HOME
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Spawns one process per GPU and uses torch's symmetric memory, which needs several GPUs
    "tests/test_distributed.py"

    # Need Triton's proton profiler (triton.profiler), which triton is built without (TRITON_BUILD_PROTON = "OFF")
    "tests/test_roofline.py"
    "tests/test_topk.py"
  ];

  # The tests launch kernels; passthru.gpuCheck runs them.
  doCheck = false;

  passthru = {
    # The version follows Triton's; update Triton instead.
    updateScript = null;

    gpuCheck = triton-kernels.overridePythonAttrs {
      requiredSystemFeatures = [ "cuda" ];
      doCheck = true;

      disabledTests = [
        # triton.runtime.errors.OutOfResources: out of resource: shared memory
        # These batched MXFP4 matmuls need more shared memory per block than consumer GPUs have (e.g. 101376 bytes on
        # an RTX 4090, compute capability 8.9).
        "1024-1024-1024-batched-mxfloat4_e2m1-float16-bfloat16-10-9"
        "1024-1024-1024-batched-mxfloat4_e2m1-bfloat16-bfloat16-10-9"
      ];
    };
  };

  meta = {
    description = "Triton kernels for matmul, mixture-of-experts top-k, reductions, SwiGLU and MXFP conversion";
    homepage = "https://github.com/triton-lang/triton/tree/main/python/triton_kernels";
    changelog = "https://github.com/triton-lang/triton/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
    inherit (triton.meta) platforms;
  };
})
