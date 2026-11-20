{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  attn-gym,
  datasets,
  einops,
  grain,
  pillow,
  pyarrow,
  renderers,
  safetensors,
  spmd-types,
  tensorboard,
  tokenizers,
  torch,
  torch-checkpointing,
  torch-remat,
  wandb,

  # tests
  expecttest,
  flash-linear-attention,
  gitMinimal,
  pytestCheckHook,
  tomli-w,
  torchvision,
  transformers,
  triton,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchtitan";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "torchtitan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I3zy0FpOV38S0ZdmIT2FKEMTkfzcAuVmzP7MZ5HILdE=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "attn-gym"
    "datasets"
    "grain"
    "pyarrow"
    "renderers"
    "spmd_types"
    "torch_checkpointing"
    "torch_remat"
  ];
  dependencies = [
    attn-gym
    datasets
    einops
    grain
    pillow
    pyarrow
    renderers
    safetensors
    spmd-types
    tensorboard
    tokenizers
    torch
    torch-checkpointing
    torch-remat
    wandb
  ]
  ++ attn-gym.optional-dependencies.linear;

  pythonImportsCheck = [ "torchtitan" ];

  nativeCheckInputs = [
    expecttest
    flash-linear-attention
    gitMinimal
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

    # The HF dataset cursor state differs with the (relaxed) datasets version from nixpkgs
    "test_hf_cursor_state_after_restore"

    # Outdated tests: _prepare_multimodal_embeds() missing 2 required keyword-only arguments
    "test_qwen35_always_calls_vision_encoder_twice"

    # AssertionError: assert I == R
    "test_qwen35_vision_projections_are_not_dense_tp_boundaries"

    # Require helion, but it is broken at the moment
    "TestHelionRoPEOverride"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # torch._inductor.exc.InductorError: LoweringException: NotImplementedError: torch.compile on current platform is not supported for CPU.
    "test_lora_forward"
  ];

  disabledTestPaths = [
    # Require the RL dependencies (torchmonarch, torchstore, vllm...)
    "tests/rl"

    # Require a GPU
    "tests/unit_tests/gpu"

    # Require a torchao nightly
    "tests/unit_tests/cpu/quantization"

    # Require internet access
    "tests/unit_tests/cpu/components/test_tokenizer.py"
  ];

  meta = {
    description = "PyTorch native platform for training generative AI models";
    changelog = "https://github.com/pytorch/torchtitan/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/pytorch/torchtitan";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
