{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  wheel,
  aiofiles,
  aiohttp,
  importlib-metadata,
  nest-asyncio,
  psutil,
  pyyaml,
  torch,
  typing-extensions,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  stdenv,
}:

buildPythonPackage rec {
  pname = "torchsnapshot";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "torchsnapshot";
    rev = "refs/tags/${version}";
    hash = "sha256-F8OaxLH8BL6MPNLFv1hBuVmeEdnEQ5w2Qny6by1wP6k=";
  };

  build-system = [
    setuptools
    wheel
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

  meta = with lib; {
    description = "Performant, memory-efficient checkpointing library for PyTorch applications, designed with large, complex distributed workloads in mind";
    homepage = "https://github.com/pytorch/torchsnapshot/";
    changelog = "https://github.com/pytorch/torchsnapshot/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
    broken =
      # https://github.com/pytorch/torchsnapshot/issues/175
      pythonAtLeast "3.12"
      # ModuleNotFoundError: No module named 'torch._C._distributed_c10d'; 'torch._C' is not a package
      || stdenv.hostPlatform.isDarwin;
  };
}
