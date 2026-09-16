{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  cloudpickle,
  fabric,
  numpy,
  torch,
  nix-update-script,
  pytestCheckHook,
  submitit,
  transformers,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchrunx";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "apoorvkh";
    repo = "torchrunx";
    tag = finalAttrs.version;
    hash = "sha256-cb9X65rnacgB59NdjEVpReFZD1wvC9GWmE0BULnCTow=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    cloudpickle
    fabric
    numpy
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    submitit
    transformers
  ];

  pythonImportsCheck = [
    "torchrunx"
  ];

  disabledTests = [
    # RuntimeError: Not in a SLURM job
    "test_launch"
    # RuntimeError: Could not detect "srun", are you indeed on a slurm cluster?
    "test_submitit"
    #  RuntimeError: workers_per_host="gpu", but no GPUs detected on: ['localhost'].
    "test_distributed_train"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easily run PyTorch on multiple GPUs & machines";
    homepage = "https://github.com/apoorvkh/torchrunx";
    changelog = "https://github.com/apoorvkh/torchrunx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
