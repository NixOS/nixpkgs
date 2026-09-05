{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  safetensors,
  torch,
  typing-extensions,

  # tests
  expecttest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "torch-checkpointing";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "torch_checkpointing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2D9iJVLPKUp5jAnqUHr/cdv0rb+mvWVr8AVkEM3qUjw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    safetensors
    torch
    typing-extensions
  ];

  pythonImportsCheck = [ "torch_checkpointing" ];

  nativeCheckInputs = [
    expecttest
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: Unexpected response from worker process: Traceback (most recent call last):
    # TypeError: timedout_subprocess_init_fn() takes 0 positional arguments but 2 were given
    "test_subprocess_initialization_timeout"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "test_write_read_multiple_dtypes"
  ];

  meta = {
    description = "High-performance asynchronous checkpointing for PyTorch";
    homepage = "https://github.com/meta-pytorch/torch_checkpointing";
    changelog = "https://github.com/meta-pytorch/torch_checkpointing/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
