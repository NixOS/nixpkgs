{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiofiles,
  aiohttp,
  importlib-metadata,
  nest-asyncio,
  psutil,
  pyyaml,
  torch,
  typing-extensions,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "torchsnapshot";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "torchsnapshot";
    rev = "refs/tags/${version}";
    hash = "sha256-F8OaxLH8BL6MPNLFv1hBuVmeEdnEQ5w2Qny6by1wP6k=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiofiles
    aiohttp
    importlib-metadata
    nest-asyncio
    psutil
    pyyaml
    torch
    typing-extensions
  ];

  pythonImportsCheck = [ "torchsnapshot" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # torch.distributed.elastic.multiprocessing.errors.ChildFailedError:
    # AssertionError: "Socket Timeout" does not match "wait timeout after 5000ms
    "test_linear_barrier_timeout"
  ];

  meta = {
    description = "Performant, memory-efficient checkpointing library for PyTorch applications, designed with large, complex distributed workloads in mind";
    homepage = "https://github.com/pytorch/torchsnapshot/";
    changelog = "https://github.com/pytorch/torchsnapshot/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # ModuleNotFoundError: No module named 'torch._C._distributed_c10d'; 'torch._C' is not a package
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
