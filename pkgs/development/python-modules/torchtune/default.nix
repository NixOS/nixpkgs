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
  mlflow,
  pytest-integration,
  pytest-mock,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "torchtune";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "torchtune";
    tag = "v${version}";
    hash = "sha256-evhQBpZiUXriL0PAYkEzGypH21iRs37Ix6Nl5YAyeQ0=";
  };

  build-system = [
    setuptools
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
  ]
  ++ huggingface-hub.optional-dependencies.hf_transfer;

  pythonImportsCheck = [ "torchtune" ];

  nativeCheckInputs = [
    comet-ml
    mlflow
    pytest-integration
    pytest-mock
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

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
    # AssertionError: actual: -83.3048095703125, expected: -83.15229797363281
    "test_forward"
    "test_forward_kv_cache"
    "test_forward_with_2d_pos_ids"
    "test_forward_with_curr_pos"
    "test_forward_with_packed_pos"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fatal Python error: Segmentation fault
    "test_forward_gqa"
  ];

  meta = {
    description = "PyTorch native post-training library";
    homepage = "https://github.com/meta-pytorch/torchtune";
    changelog = "https://github.com/meta-pytorch/torchtune/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # sentencepiece 0.21.0 segfaults when initialized on Darwin
      # See https://github.com/NixOS/nixpkgs/issues/466092
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
