{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  datasets,
  einops,
  pillow,
  safetensors,
  spmd-types,
  tensorboard,
  tokenizers,
  torch,
  torch-checkpointing,
  torchdata,
  transformers,
  tyro,
  wandb,

  # tests
  expecttest,
  flash-linear-attention,
  pytestCheckHook,
  tomli-w,
  torchvision,
  triton,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchtitan";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "torchtitan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wkhx1uGgzCLMiBDS2h7V6NVcaJYcSyDXkZkn2hUbgHE=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "spmd_types"
  ];
  dependencies = [
    datasets
    einops
    pillow
    safetensors
    spmd-types
    tensorboard
    tokenizers
    torch
    torch-checkpointing
    torchdata
    tyro
    wandb
  ];

  pythonImportsCheck = [ "torchtitan" ];

  nativeCheckInputs = [
    expecttest
    flash-linear-attention
    pytestCheckHook
    tomli-w
    torchvision
    transformers
    triton
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Require internet access
    "test_list_files"

    # Require helion, but it is broken at the moment
    "TestHelionRoPEOverride"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # torch._inductor.exc.InductorError: LoweringException: NotImplementedError: torch.compile on current platform is not supported for CPU.
    "test_lora_forward"
  ];

  disabledTestPaths = [
    # Require internet access
    "tests/unit_tests/test_tokenizer.py"
  ];

  meta = {
    description = "PyTorch native platform for training generative AI models";
    changelog = "https://github.com/pytorch/torchtitan/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/pytorch/torchtitan";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
