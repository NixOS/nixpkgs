{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  blobfile,
  datasets,
  huggingface-hub,
  kagglehub,
  numpy,
  omegaconf,
  pillow,
  psutil,
  safetensors,
  sentencepiece,
  tiktoken,
  tokenizers,
  torch,
  torchdata,
  tqdm,
  torchao,
  torchvision,

  # tests
  comet-ml,
  expecttest,
  mlflow,
  pytest-integration,
  pytest-mock,
  pytestCheckHook,
  tensorboard,
  writableTmpDirAsHomeHook,

  # passthru
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchtune";
  version = "0.6.1-unstable-2026-04-23";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "torchtune";
    rev = "bd2a0fc7c31430972728494fa01aaeeb0ebf1ba1";
    hash = "sha256-6jE8+ZCm46qyoSOCkBjxsXNvtVEOUP6v3NEmMh+ocl8=";
  };

  postPatch = ''
    substituteInPlace \
      tests/torchtune/modules/low_precision/test_nf4_dispatch_registration.py \
      torchtune/modules/low_precision/_register_nf4_dispatch_ops.py \
      torchtune/modules/low_precision/nf4_linear.py \
      torchtune/modules/peft/dora.py \
      torchtune/modules/peft/lora.py \
      --replace-fail \
        "from torchao.quantization import to_nf4" \
        "from torchao.dtypes import to_nf4" \

    substituteInPlace \
      tests/torchtune/models/llama2/test_lora_llama2.py \
      tests/torchtune/models/phi3/test_lora_phi3.py \
      tests/torchtune/modules/low_precision/test_nf4_linear.py \
      tests/torchtune/training/test_distributed.py \
      torchtune/modules/common_utils.py \
      torchtune/training/_activation_offloading.py \
      --replace-fail \
        "from torchao.quantization import NF4Tensor" \
        "from torchao.dtypes.nf4tensor import NF4Tensor"

    substituteInPlace \
      tests/torchtune/modules/peft/test_dora.py \
      tests/torchtune/modules/peft/test_lora.py \
      torchtune/training/_distributed.py \
      --replace-fail \
        "from torchao.quantization import NF4Tensor, to_nf4" \
        "from torchao.dtypes.nf4tensor import NF4Tensor, to_nf4"

    substituteInPlace \
      torchtune/modules/low_precision/nf4_linear.py \
      torchtune/modules/peft/dora.py \
      torchtune/modules/peft/lora.py \
      --replace-fail \
        "from torchao.quantization.quantize_.workflows.nf4.nf4_tensor import linear_nf4" \
        "from torchao.dtypes.nf4tensor import linear_nf4"

    substituteInPlace torchtune/modules/low_precision/_register_nf4_dispatch_ops.py \
      --replace-fail \
        "from torchao.quantization.quantize_.workflows.nf4.nf4_tensor import implements as nf4_tensor_impl" \
        "from torchao.dtypes.nf4tensor import implements as nf4_tensor_impl"
  '';

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "pyarrow"
  ];
  dependencies = [
    blobfile
    datasets
    huggingface-hub
    kagglehub
    numpy
    omegaconf
    pillow
    psutil
    safetensors
    sentencepiece
    tiktoken
    tokenizers
    torch
    torchdata
    tqdm

    # Not explicitly listed as requirements, but effectively imported at runtime
    torchao
    torchvision
  ];

  pythonImportsCheck = [ "torchtune" ];

  nativeCheckInputs = [
    comet-ml
    expecttest
    mlflow
    pytest-integration
    pytest-mock
    pytestCheckHook
    tensorboard
    writableTmpDirAsHomeHook
  ];

  # Exclude `regression` which depends on a specific llama model and `recipies` which are sample code
  enabledTestPaths = [ "tests/torchtune" ];

  disabledTests = [
    # AssertionError (tensors are not equal)
    "test_stop_tokens"
    "test_stop_tokens_batched"
    "test_stop_tokens_batched_uneven_stopping"
    "test_stop_tokens_batched_uneven_stopping_left_padded"

    # RuntimeError: not allowed to set torch.backends.cudnn flags after disable_global_flags;
    # please use flags() context manager instead
    "test_deterministic_false"
    "test_deterministic_true"

    # TypeError: exceptions must be derived from Warning, not <class 'NoneType'>
    "test_deprecated"

    # Flaky
    # AssertionError: (numbers slightly different than expected))
    "test_forward"
    "test_forward_kv_cache"
    "test_forward_with_2d_pos_ids"
    "test_forward_with_curr_pos"
    "test_forward_with_packed_pos"
    "test_local_kv_cache"

    # TypeError: exceptions must be derived from Warning, not <class 'NoneType'>
    "test_deprecate_parameter"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    # RuntimeError: Error in dlopen:
    # /tmp/yae2xK/mha/data/aotinductor/model/ckk2zlroqn6hgq5vvpy7bcjikztqmwqkek3njxe2gvvwp244hjny.wrapper.so:
    # cannot enable executable stack as shared object requires: Invalid argument
    "test_attention_aoti"
    "test_tile_positional_embedding_aoti"
    "test_tiled_token_positional_embedding_aoti"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fatal Python error: Segmentation fault
    "test_forward_gqa"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # tests/torchtune/training/test_distributed.py
    "test_init_from_env_no_dup"
    "test_init_from_env_dup"
  ];

  disabledTestPaths = [
    # MLFlowLogger uses the deprecated mlflow filesystem store, which throws an
    # error since mlflow 3.13. See https://github.com/NixOS/nixpkgs/pull/532943
    "tests/torchtune/training/test_metric_logging.py::TestMLFlowLogger"

    # TypeError: HfHubHTTPError.__init__() missing 1 required keyword-only argument: 'response'
    "tests/torchtune/_cli/test_download.py::TestTuneDownloadCommand::test_download_calls_snapshot"
    "tests/torchtune/_cli/test_download.py::TestTuneDownloadCommand::test_gated_repo_error_no_token"
    "tests/torchtune/_cli/test_download.py::TestTuneDownloadCommand::test_gated_repo_error_with_token"

    # NameError: name 'TypeVar' is not defined
    "tests/torchtune/rlhf/loss/test_dpo_loss.py"
    "tests/torchtune/rlhf/loss/test_ppo_loss.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fail due to floating-point precision differences
    "tests/torchtune/models/flux/test_flux_autoencoder.py::TestFluxAutoencoder::test_encode"
    "tests/torchtune/modules/peft/test_dora.py::TestDoRALinear::test_qdora_parity[True-dtype1]"
    "tests/torchtune/modules/peft/test_lora.py::TestLoRALinear::test_qlora_parity[True-dtype1]"
    "tests/torchtune/modules/test_common_utils.py::TestLocalKVCache::test_local_kv_cache[llama_decoder_model]"

    # hangs
    "tests/torchtune/utils"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "PyTorch native post-training library";
    homepage = "https://github.com/meta-pytorch/torchtune";
    # changelog = "https://github.com/meta-pytorch/torchtune/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      sarahec
    ];
  };
})
