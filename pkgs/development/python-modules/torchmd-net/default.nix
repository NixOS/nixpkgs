{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  ase,
  h5py,
  lightning,
  numpy,
  torch,
  torch-geometric,
  tqdm,
  warp-lang,

  # tests
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  llvmPackages,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchmd-net";
  version = "3.0.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "torchmd";
    repo = "torchmd-net";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FBeeNkc7mJQYmMwlsW3Un+3RHvErJM7rWKUqSCYYUCM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRemoveDeps = [
    # Not a runtime dependency
    "setuptools"
  ];
  dependencies = [
    ase
    h5py
    lightning
    numpy
    torch
    torch-geometric
    tqdm
    warp-lang
  ];

  pythonImportsCheck = [ "torchmdnet" ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  checkInputs = lib.optionals stdenv.cc.isClang [
    # torch._inductor.exc.InductorError: CppCompileError: C++ compile error
    # fatal error: 'omp.h' file not found
    llvmPackages.openmp
  ];

  disabledTests = [
    # Require internet access
    "test_dataset_s66x8"

    # Failed: torch.compile failed on TorchScripted tensornet model:
    # torch.compile does not support compiling torch.jit.script or torch.jit.freeze models directly.
    "test_torchscript_then_compile"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # torch._inductor.exc.InductorError: ImportError: ...
    # symbol not found in flat namespace '___kmpc_barrier'
    "test_ase_calculator"
    "test_torch_export_then_compile"
  ];

  meta = {
    description = "Library to train state-of-the-art neural networks potentials (NNPs)";
    homepage = "https://github.com/torchmd/torchmd-net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
