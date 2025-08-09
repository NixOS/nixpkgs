{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ultralytics-thop";
  version = "2.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ultralytics";
    repo = "thop";
    tag = "v${version}";
    hash = "sha256-1osW/yTyNZWYVqyRBBoT5FOO9nAvZL2Bmo0vJhJcwu8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    torch
  ];

  pythonImportsCheck = [ "thop" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/ultralytics/thop";
    changelog = "https://github.com/ultralytics/thop/releases/tag/${src.tag}";
    description = "Profile PyTorch models by computing the number of Multiply-Accumulate Operations (MACs) and parameters";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ osbm ];
  };
}
