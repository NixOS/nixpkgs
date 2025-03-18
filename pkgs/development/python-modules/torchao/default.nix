{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  torch,

  # tests
  bitsandbytes,
  expecttest,
  fire,
  pytestCheckHook,
  parameterized,
  tabulate,
  unittest-xml-reporting,
}:

buildPythonPackage rec {
  pname = "ao";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "ao";
    tag = "v${version}";
    hash = "sha256-RW8VpqxxoWhat5nC8b88jKSxFClxaQ+ukaqbX5Gxq8o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    torch
  ];

  env = {
    USE_SYSTEM_LIBS = true;
  };

  pythonImportsCheck = [
    "torchao"
  ];

  nativeCheckInputs = [
    bitsandbytes
    expecttest
    fire
    parameterized
    pytestCheckHook
    tabulate
    unittest-xml-reporting
  ];

  meta = {
    description = "PyTorch native quantization and sparsity for training and inference";
    homepage = "https://github.com/pytorch/ao";
    changelog = "https://github.com/pytorch/ao/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
