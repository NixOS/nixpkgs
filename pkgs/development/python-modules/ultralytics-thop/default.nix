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
  version = "2.0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ultralytics";
    repo = "thop";
    tag = "v${version}";
    hash = "sha256-icBfJagsK2DabMC8xgWNT1o3EdDGL+U2UyIf/LfugYc=";
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
